require 'rexml/document'

include REXML

module Embulk
  module Parser
    class Flexml < ParserPlugin
      Plugin.register_parser("flexml", self)

      def self.transaction(config, &control)
        schema = config.param("schema", :array)
        schema_serialized = schema.inject({}) do |memo, s|
          memo[s["name"]] = s
          if s["type"] == "timestamp"
            memo[s["name"]].merge!({
              "format" => s["format"],
              "timezone" => s["timezone"]
            })
          end
          memo
        end.to_h
        task = {
          :schema => schema_serialized,
          :root => config.param("root", :string)
        }
        columns = schema.each_with_index.map do |c, i|
          Column.new(i, c["name"], c["type"].to_sym)
        end
        yield(task, columns)
      end

      def run(file_input)
        while file = file_input.next_file
          begin
            xml_text = file.read
            doc = Document.new(xml_text)
            doc.elements.each(@task[:root]) do |e|
              values = @task[:schema].map do |f, c|
                row = if c.has_key?("xpath")
                    XPath.first(e, c["xpath"])
                  else
                    e
                  end

                unless row.nil?
                  val = if c.has_key?("attribute")
                    row.attributes[c["attribute"]]
                  else
                    row.text
                  end
                  convert(val, c)
                else
                  nil
                end
              end

              @page_builder.add(values)
            end
          rescue Exception => e
            Embulk.logger.error "Failed to parse xml: #{e.message}"
          end
        end

        @page_builder.finish
      end

      def convert(val, config)
        v = val.nil? ? "" : val
        case config["type"]
        when "string"
          v
        when "long"
          v.to_i
        when "double"
          v.to_f
        when "boolean"
          ["yes", "true", "1"].include?(v.downcase)
        when "timestamp"
          unless v.empty?
            dest = Time.strptime(v, config["format"])
            return dest.utc if config["timezone"].nil?

            utc_offset = dest.utc_offset
            zone_offset = Time.zone_offset(config["timezone"])
            dest.localtime(zone_offset) + utc_offset - zone_offset
          else
            nil
          end
        else
          raise "Unsupported type '#{type}'"
        end
      end
    end
  end
end
