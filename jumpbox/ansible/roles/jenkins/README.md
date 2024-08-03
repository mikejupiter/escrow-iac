# Installing Jenkins


## Generate the plugins.txt from the existed Jenkins

1) Go to http://localhost:5555/script.

2) Exec:

```
import jenkins.model.*
import hudson.PluginWrapper

def plugins = Jenkins.instance.pluginManager.plugins
def output = new StringBuilder()

plugins.each { PluginWrapper plugin ->
    def pluginName = plugin.shortName
    def pluginVersion = plugin.version
    output.append("${pluginName}:${pluginVersion}\n")
}

// Save to file on Jenkins master
def file = new File('/var/jenkins_home/plugins.txt')
file.text = output.toString()
```

3) Copy into `files/plugins.txt`