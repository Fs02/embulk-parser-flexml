# embulk-parser-flexml

Parser plugin for [Embulk](https://github.com/embulk/embulk).

Flexible xml parser for embulk. read data using xpath and from attributes

* **Plugin type**: parser
* **Load all or nothing**: yes
* **Resume supported**: no

## Configuration

- **type**: specify this plugin as `flexml` .
- **root**: root property to start fetching each entries, specify in *path/to/node* style (string, required)
- **schema**: specify the attribute of table and data type (required)
    - **name**: name of the attribute (string, required)
    - **type**: type of the attribute (string, required)
    - **attribute**: if specified, value of this attribute will be the output, otherwise child will be the output (string, optional)
    - **xpath**: child element to select (string, required)

## Example

### Configuration

```yaml
parser:
    type: flexml
    root: Class/Users/User
    schema:
        - { name: name, type: string, attribute: name }
        - { name: age, type: long, attribute: age }
        - { name: about, type: string, xpath: About }
        - { name: facebook, type: string, xpath: "SocialMedia[@type='facebook']", attribute: url }
        - { name: twitter, type: string, xpath: "SocialMedia[@type='twitter']", attribute: url }
```

### XML

```xml
<?xml version="1.0" encoding="utf-8" standalone="no"?>
<Class>
    <Users>
        <User name="Locatelli" age="23">
            <About>
                Manuel Locatelli Cavaliere OMRI (born 8 January 1998) is an Italian professional footballer who plays as a midfielder for Serie A club Juventus, on loan from Serie A club Sassuolo, and the Italy national team.
            </About>
            <SocialMedia type="facebook" url="https://www.facebook.com/locamanuel73"/>
            <SocialMedia type="twitter" url="https://twitter.com/locamanuel73"/>
        </User>
    </Users>
</Class>
```