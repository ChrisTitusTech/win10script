Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$ErrorActionPreference = 'SilentlyContinue'
$wshell = New-Object -ComObject Wscript.Shell
$Button = [System.Windows.MessageBoxButton]::YesNoCancel
$ErrorIco = [System.Windows.MessageBoxImage]::Error
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	Exit
}

# GUI Specs
Write-Host "Checking winget..."

Try{
    # Im just gonna sneak this in here bc why not lmao 
    New-Item -ItemType directory -Path "$PSScriptRoot/dump"
	# Check if winget is already installed
	$er = (invoke-expression "winget -v") 2>&1
	if ($lastexitcode) {throw $er}
	Write-Host "winget is already installed."
}
Catch{
	# winget is not installed. Install it from the Github release
	Write-Host "winget is not found, installing it right now."
	$download = "https://github.com/microsoft/winget-cli/releases/download/v1.0.11692/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
	$output = "$PSScriptRoot/dump/" + "winget-latest.appxbundle"
	Write-Host "Dowloading latest release"
	Invoke-WebRequest -Uri $download -OutFile $output
	Write-Host "Installing the package"
	Add-AppxPackage -Path $output
}
Finally {
	# Start installing the packages with winget
	# Get-Content .\winget.txt | ForEach-Object {
	#	iex ("winget install -e " + $_)
	# }
    # Create the App Dump Folder
}

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(1050,700)
$Form.text                       = "Windows 10 Debloat By Chris Titus"
$Form.StartPosition              = "CenterScreen"
$Form.TopMost                    = $false
$Form.BackColor                  = [System.Drawing.ColorTranslator]::FromHtml("#b8b8b8")
$Form.AutoScaleDimensions     = '192, 192'
$Form.AutoScaleMode           = "Dpi"
$Form.AutoSize                = $True
$Form.ClientSize              = '1050, 700'
$Form.FormBorderStyle         = 'FixedSingle'

# GUI Icon
$iconBase64                      = 'AAABAAMAMDAAAAEAIACoJQAANgAAACAgAAABACAAqBAAAN4lAAAQEAAAAQAgAGgEAACGNgAAKAAAADAAAABgAAAAAQAgAAAAAAAAJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEZGRgKxsbEBR0dHAq+vrwEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///8C////Dt3d3Sm/v785wMDAOsDAwDrAwMA6wMDAOsDAwDrBwcE7wMDAPa6urjzm5uYV////AQAAAAAAAAAAAAAAAAAAAAD///8C3NzcIFNTU3O+vr5NVFRUdLy8vCj///8DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////Af///wv///8R////BQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///wL///8Xv7+/WYWFhaSPj4+vjo6OrY6Ojq2Ojo6tjo6OrY+Pj62Ojo6wh4eHqGxsbJfMzMwu////AwAAAAAAAAAAAAAAAP///wH///8O8PDwRnZ2dqnU1NRvdHR0ntLS0jn///8EAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////BqmpqUF7e3tu////GP///wEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////Af///w67u7tXiIiIua2trcecnJzEnJycwJubm7+bm5u/m5ubv52dncCKiorItra2m/X19Vf39/cg////AwAAAAAAAAAAAAAAAP///wPU1NQuhISEnn9/f7jX19dodnZ2ltPT0zX///8DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////B6mpqVZ7e3uc////Mf///wgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///wv///8J////CNjY2Dd8fHyonJycy5ycnM+mpqbSkJCQ2I6OjteOjo7Xjo6O2IuLi9KFhYXFgICAs2hoaKGvr68+////BQAAAAAAAAAAAAAAAP///wPc3Nw1hISEsISEhL/X19drd3d3l9PT0zX///8DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////B7W1tVGFhYW2jIyMhvX19R3///8BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJSUlGW8vLxZ7e3tQNHR0WtfX1/UlJSUz6GhocyJiYnci4uLzYaGhryGhoa7fX19wYGBganU1NRZxsbGRbS0tEXa2toe////AwAAAAAAAAAAAAAAAP///wXi4uI2jIyMrImJicbKysqUf39/ptXV1Tb///8DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////B7W1tVCHh4fDf39/pfz8/CT///8CAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFpaWsdra2vQeXl5wYqKisBvb2/dmpqa0ZycnM5qamrcxcXFjfX19Vbj4+Ni6enpX+bm5kX///8a////C////wj///8E////AQAAAAAAAAAA////Au7u7hnAwMBokpKSuI+Pj9OEhITSeHh4u9vb2zj///8DAAAAAAAAAAAAAAAAAAAAAAAAAAD///8B////Cri4uFWJiYnBiIiInf///yH///8BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKqqqmOYmJiHhYWFpnt7e8BwcHDYampq34SEhNppaWnhkJCQs7GxsZF1dXWzhISEqp+fn4i3t7dm1tbWR/X19S7///8d////Ev///wj///8C////A9ra2jN0dHS0k5OTyZKSktSVlZXQf39/utnZ2Tj///8DAAAAAAAAAAAAAAAAAAAAAAAAAAD///8E29vbKqqqqoaOjo7HiIiInv///yP///8DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///wv///8V/f39JPX19UKSkpKbDw8P+BQUFPhoaGjVd3d3yGxsbNJoaGjdbGxs4m5ubuBwcHDZdnZ2y4CAgLWRkZGalZWVgb+/v0X///8P////B+fn5zKJiYmvl5eXy5GRkdOVlZXOfn5+utnZ2Tj///8EAAAAAAAAAAAAAAAAAAAAAAAAAAD///8HrKysU3Nzc8uUlJTOkZGRreXl5Un5+fkQ////AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///8B////Av///xGKiop+CwsL+goKCvyWlpaY7u7uT7y8vF+goKB/i4uLnnt7e7lxcXHNbW1t2mxsbOFubm7iZGRk4JKSkqrHx8dh5OTkQPDw8FGNjY20l5eXypGRkdOVlZXNgoKCvuLi4kj///8Q////Bv///wP///8BAAAAAAAAAAD///8GvLy8T4KCgsuWlpbQkJCQyHl5eaPl5eUp////AgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////Af///w6IiIh8CwsL+goKCvyFhYWC////FP///wr///8S////H/Hx8TLR0dFLsbGxapaWloqCgoKoc3NzwGdnZ85iYmLOaWlpwn9/f7uDg4PPnZ2dzZOTk9WXl5fPhYWF0JSUlKOxsbFr0dHRR/Ly8i3///8b////D////wj///8Ju7u7T4GBgcqWlpbPlpaWy4mJiafv7+8s////AwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///w6IiIh8CwsL+goKCvyDg4OA////EP///wH///8B////Af///wP///8G////DP///xb+/v4l6OjoOsXFxVWlpaV0ioqKlHNzc7F5eXnHampq2m5ubuSJiYnZgoKC3319feKIiIjYiIiIyYuLi7OVlZWVqampc8bGxlPv7+89zc3NbIODg86WlpbPlpaWypCQkKv09PQ6////BgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///w6IiIh8CwsL+goKCvyDg4OA////EAAAAAAAAAAAAAAAAAAAAAAAAAAA////Af///wH///8C////BP///wj///8P////Gvr6+izn5+dbRUVF0wYGBv8yMjLth4eHyXl5ec54eHjae3t74IGBgeKEhIThhISE3IWFhdCDg4PCi4uLx4uLi9uWlpbQmZmZy3h4eMmMjIx9////FP///wEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///w6IiIh7CwsL+goKCvyFhYWD////EQAAAAAAAAAAAAAAAAAAAAD///8D////CP///wj///8F////AQAAAAAAAAAA////Af///wT///8sQUFBxQAAAP8xMTHf6OjoZtLS0k+wsLBrl5eXi4WFhal5eXnBdHR003Z2dt13d3fid3d35IqKiuGZmZnTnZ2dzXd3d9aPj4+f////NP///xX///8L////Bv///wP///8B////AQAAAAAAAAAAAAAAAP///wySkpJzDg4O+AcHB/55eXmV////Gf///wEAAAAAAAAAAP///wXj4+MopqamW56enmK4uLg7////CQAAAAAAAAAAAAAAAP///wL///8pQEBAxAEBAf8sLCzZ5ubmPv///wr///8M////Fv39/Sbl5eU7xMTEV6ampnaPj4+Wf39/s319fcxhYWHidnZ23Xx8fNuEhITPkJCQp5ubm4WxsbFmzs7OSO7u7jD///8e////EgAAAAAAAAAAAAAAAP///wm1tbVcGRkZ7QICAv9OTk7D////Ov///wj///8C////BP///x6QkJCEGRkZ7RQUFPNycnKF////Ef///wH///8B////Af///wP///8qQEBAxAEBAf8sLCzZ5eXlPP///wX///8C////Av///wP///8E////Cf///xD///8c/Pz8MczMzHElJSXnBwcH/k5OTt+RkZHBgoKCyoCAgNOAgIDSgoKCx4eHh7SLi4ucjY2NdwAAAAAAAAAAAAAAAP///wTz8/M4PT09ygEBAf8UFBTzj4+PlP///zr///8f////Lru7u3MwMDDeAQEB/xwcHOu0tLRh////Df///xD///8b////Hf///x////9BR0dHygAAAP8wMDDd7OzsUv///yH///8e////HP///xP///8J////FP///x3///8f////JN3d3V8mJibkAAAA/2NjY8b///9p4+PjasbGxoevr6+ilZWVs4WFhcB6enrOeHh4tgAAAAAAAAAAAAAAAP///wH///8Xk5OTgBQUFPMBAQH/FRUV809PT8NwcHCjXFxctyIiIugDAwP/CQkJ/GZmZqj///8q////EIyMjGBRUVGrVFRUrVRUVK5hYWG6LCws6wEBAf8fHx/yYGBgwFVVVa9UVFSuUFBQrXt7e3T///8tc3NzfVFRUa1UVFSuVlZWr15eXsMZGRn0AgIC/zU1NeViYmK6W1tbtGFhYbhnZ2e7ubm5eerq6kW8vLxUpqamVwAAAAAAAAAAAAAAAAAAAAD///8F/Pz8L3Nzc50VFRXyAgIC/wEBAf8EBAT/AgIC/wEBAf8NDQ35VVVVuOLi4kX///8L////FWFhYZgDAwP/AgIC/wICAv8BAQH/AgIC/wICAv8CAgL/AQEB/wICAv8CAgL/AQEB/0hISLX///9IPDw8wQAAAP8CAgL/AgIC/wEBAf8CAgL/AgIC/wEBAf8BAQH/AQEB/wEBAf8FBQX+dXV1hv///xT///8I////CAAAAAAAAAAAAAAAAAAAAAAAAAAA////CPn5+S6ampp6RkZGwCQkJOIaGhrsHx8f5js7O8uDg4OM6urqPP///w3///8C////EHV1dXwqKirYKysr2SsrK9krKyvZKysr2SsrK9krKyvZKysr2SsrK9krKyvZKCgo2mBgYJX///85VlZWoCgoKNorKyvZKysr2SsrK9krKyvZKysr2SsrK9krKyvZKysr2SsrK9ksLCzWhYWFbf///w3///8BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///wT///8T9/f3K83NzUK0tLRMw8PDRu/v7zH///8X////Bv///wEAAAAA////Benp6R7f39814eHhOOHh4Tjh4eE44eHhOOHh4Tjh4eE44eHhOOHh4Tjh4eE439/fNuXl5ST///8Q5OTkJ9/f3zfh4eE44eHhOOHh4Tjh4eE44eHhOOHh4Tjh4eE44eHhOOHh4Tjf39806+vrG////wQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///////wAA////////AAD///////8AAP///////wAA////////AAD///////8AAP///////wAA////////AAD///////8AAP///////wAA////////AAD///////8AAP///////wAA////////AAD///////8AAPwA/1///wAA+AH+X/v/AADwAP5f+f8AAPAH/h/5/wAAAH/+H/n/AACAB/wf8f8AAPAAPB/x/wAA+OAcH/D/AAD4/gAP8P8AAPj/8ADw/wAA+P/+AAD/AAD4//44AH8AAPj//j/AHwAA+Ph+P/gBAAD4eP4/+MAAAPgA4AOADwAA/AHAAQAHAAD/A+ABAA8AAP///////wAA////////AAD///////8AAP///////wAA////////AAD///////8AAP///////wAA////////AAD///////8AAP///////wAA////////AAD///////8AAP///////wAA////////AAD///////8AACgAAAAgAAAAQAAAAAEAIAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD29vYJubm5JK6uri2vr68tr6+vLbCwsC2srKwvo6OjJv///wQAAAAAAAAAAAAAAACtra0Td3d3RHt7e0Senp4YAAAAAAAAAAAAAAAAAAAAAP///wHq6uoM7u7uBwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/v7+DKqqql+YmJiql5eXrZaWlqyWlpaslZWVr5WVlaWfn59j////CwAAAAAAAAAA////BbCwsE+RkZGVlJSUhbKysi8AAAAAAAAAAAAAAAAAAAAA////BoyMjFioqKg5////AQAAAAAAAAAAAAAAAAAAAAAAAAAA////Cf///waqqqpIj4+PvKOjo8+WlpbSkJCQ0pCQkNKOjo7Lj4+Pr5mZmWzp6ekPAAAAAAAAAAD///8NjIyMjJSUlKSZmZmAs7OzLAAAAAAAAAAAAAAAAAAAAAD///8GlZWVcJeXl4Hi4uITAAAAAAAAAAAAAAAAAAAAAAAAAAB9fX2DpKSkbY6Ojp2FhYXUlpaW0o+Pj8OcnJydlZWVoKCgoHbBwcE7qKioLu7u7gcAAAAAAAAAAPn5+Rebm5uRlZWVv5CQkKO7u7stAAAAAAAAAAAAAAAAAAAAAP///waZmZlzh4eHq9bW1h8AAAAAAAAAAAAAAAAAAAAAAAAAAIGBgYyBgYGqfHx8xnV1ddt4eHjdiIiIuKysrIiUlJSUr6+vasPDwz7n5+cj/v7+Ev///wX///8BoqKiTI6Ojr6SkpLUhISEvcPDwy4AAAAAAAAAAAAAAAAAAAAA3d3dG5qampCNjY2n3NzcHgAAAAAAAAAAAAAAAAAAAAAAAAAA////DPDw8BvGxsZRKysr3iwsLOqKioqre3t7tHFxcc5xcXHWdHR0z319fbuBgYGfs7OzUf///xasrKxckZGRyJSUlNGJiYm6xMTEMAAAAAAAAAAAAAAAAAAAAACqqqo/hoaGxpOTk7uwsLBQ////BQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAM7OzioiIiLZIiIi3djY2Dzk5OQivr6+PqSkpF+Pj4+EgICAqHR0dMN3d3e8f39/n4qKiqqSkpLOlpaW0oyMjMmkpKR9v7+/P9/f3yL9/f0P////BbGxsT+Li4vHk5OTzpKSkoP///8LAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAz8/PKyIiItkgICDcysrKLAAAAAAAAAAA////Av///wn39/cW09PTK66urkmUlJRsiYmJkWxsbMtUVFToe3t73X5+ft2GhobQi4uLuZSUlJekpKRxqqqqfo2Njc2VlZXNlpaWluDg4BoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADPz88qIiIi2SEhIdzLy8suAAAAAAAAAAD///8B////Bf///wb///8BAAAAAP///wT///8UVlZWngsLC/5/f3+foaGheYuLi5yCgoK7fn5+0Xx8fNt6enrfjIyM3JmZmc98fHzGvr6+Tf///xD///8G////AQAAAAAAAAAAAAAAAODg4CQoKCjQGxsb6ba2tkMAAAAAAAAAAOrq6hhqampzXV1df8LCwh8AAAAAAAAAAP///whPT0+WDAwM/XZ2dmr///8H/f39EN7e3iO6uro+o6OjYJSUlIV3d3fATk5O6HNzc9mLi4u4kJCQlpycnHWurq5Surq6NQAAAAAAAAAA////E0hISKkKCgr+ZGRkmvf39yr///8ihISEehQUFPMvLy/M3d3dJ////xD///8Z////IltbW6ENDQ39hoaGeP///xv///8Y////Df///w7///8c////JoGBgYoKCgr9cXFxury8vImjo6Ook5OTuoaGhr19fX2uAAAAAAAAAAD///8DmpqaVB8fH+QODg74NDQ0zTk5OcYTExPzFRUV8H5+fnD///8WVVVVhi4uLsY0NDTGJSUl5wYGBv4uLi7dMjIyxS8vL8R8fHxsc3Nzci8vL8QyMjLFLCws3gUFBf4pKSnkOjo6yTs7O9F1dXWY1dXVP6qqqkQAAAAAAAAAAAAAAAD///8Ojo6OYTY2NsMYGBjpFhYW7C4uLsx9fX1y/Pz8FP///xBISEicHBwc5R0dHeIdHR3gHx8f3x0dHeEdHR3iHh4e4nJycn1oaGiFHR0d4x0dHeIdHR3hHx8f3x0dHeAdHR3iHBwc5E5OTpD///8LAAAAAAAAAAAAAAAAAAAAAAAAAAD///8G39/fHqKiojacnJw41dXVIv///wgAAAAA////A8HBwR62trYtuLi4Lbi4uC24uLgtuLi4Lbi4uC22trYsz8/PGMzMzBq2trYtuLi4Lbi4uC24uLgtuLi4Lbi4uC22trYtw8PDHP///wIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//////////////////////////////////////////////////////A/P//gPj+/QP4/vwD+Pz/gDj8/54A/H+f8Ax/n/iAf5/5+B+OefwDwMAwD+HAIA/////////////////////////////////////////////////////8oAAAAEAAAACAAAAABACAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC+vr4Gp6enHaWlpSCioqIhp6enDgAAAACgoKAJhoaGI5SUlAkAAAAAy8vLAa+vrwcAAAAAAAAAAAAAAADNzc0NoKCgXJqamrKUlJSylJSUn6SkpDcAAAAAnJycPZaWloWlpaUdAAAAALe3twqYmJhPubm5DAAAAAAAAAAAjIyMeICAgLqGhobNlZWVpZycnHCtra0q////BJqammyRkZGwoqKiIAAAAAC5ubkTlJSUg62trR0AAAAAAAAAANbW1hdJSUmRUFBQrJGRkW+Dg4OOgYGBlo+Pj2yRkZGlj4+Px5+fn0++vr4VqqqqMJGRkbOioqI+AAAAAAAAAAAAAAAANjY2gTU1NYQAAAAA19fXDq2trSWcnJw2a2triVhYWM+Ojo6ei4uLnYyMjKGOjo7OlJSUdtTU1A7v7+8EAAAAAEFBQW8yMjKtpaWlJ0NDQ31TU1Nc1NTUD0xMTGwyMjKyra2tLqKiojiUlJRmUlJSynR0dLuWlpaPlJSUcQAAAAB+fn4jMjIyrC0tLcQwMDCzfHx8Pj4+Po8pKSnIIiIi0zIyMq9hYWFzMTExryEhIdMuLi7NTk5Oo6ampjgAAAAAAAAAAJCQkBJcXFwqiIiIFN7e3gNra2sfY2NjJmdnZyVkZGQliIiIGWNjYyVnZ2clYmJiJmhoaB28vLwCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP//AAD//wAA//8AAP//AAD//wAAx38AAI93AACSdwAAngcAAN9xAADEIQAA//8AAP//AAD//wAA//8AAP//AAA='
$iconBytes                       = [Convert]::FromBase64String($iconBase64)
$stream                          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length)
$Form.Icon                    = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

$Form.Width                   = $objImage.Width
$Form.Height                  = $objImage.Height

$MSSansSerif = "Microsoft Sans Serif"

function Create-Panel {
	param (
		[int] $Height,
		[int] $Width,
		[int] $LocationX,
		[int] $LocationY
	)

	$Pnl = New-Object System.Windows.Forms.Panel
    $location = New-Object System.Drawing.Point($LocationX, $LocationY)

	$Pnl.Height = $Height
	$Pnl.Width = $Width
	$Pnl.Location = $location
	return $Pnl
}

function Create-Button {
    param (
        [string] $Text,
        [int] $Width,
        [int] $Height,
        [int] $LocationX,
        [int] $LocationY,
        [string] $FontName,
        [int] $FontSize
    )

    $location = New-Object System.Drawing.Point($LocationX, $LocationY)
    $font = New-Object System.Drawing.Font($FontName, $FontSize)

    $Btn = New-Object System.Windows.Forms.Button
    $Btn.Text = $Text
    $Btn.Width = $Width
    $Btn.Height = $Height
    $Btn.Location = $location
    $Btn.Font = $font
    return $Btn
}

function Create-Label {
    param (
        [string] $Text,
        [bool] $AutoSize,
        [int] $Width,
        [int] $Height,
        [int] $LocationX,
        [int] $LocationY,
        [string] $FontName,
        [int] $FontSize
    )

    $location = New-Object System.Drawing.Point($LocationX, $LocationY)
    $font = New-Object System.Drawing.Font($FontName, $FontSize)

    $Lbl = New-Object System.Windows.Forms.Label
    $Lbl.Text = $Text
    $Lbl.AutoSize = $AutoSize
    $Lbl.Width = $Width
    $Lbl.Height = $Height
    $Lbl.Location = $location
    $Lbl.Font = $font
    return $Lbl
}

# Panels
$Panel1 = Create-Panel -Height 800 -Width 219 -LocationX 6 -LocationY 54
$Panel2 = Create-Panel -Height 386 -Width 211 -LocationX 239 -LocationY 54
$Panel3 = Create-Panel -Height 387 -Width 220 -LocationX 464 -LocationY 54
$Panel4 = Create-Panel -Height 179 -Width 340 -LocationX 699 -LocationY 55

# Labels
$Label1 = Create-Label -Text "Install" -AutoSize $True -Width 230 -Height 25 -LocationX 76 -LocationY 11 -FontName $MSSansSerif -FontSize 24
$Label2 = Create-Label -Text "(Windows 1809+ Required)" -AutoSize $True -Width 25 -Height 10 -LocationX 26 -LocationY 5 -FontName $MSSansSerif -FontSize 10
$Label3 = Create-Label -Text "System Tweaks" -AutoSize $True -Width 230 -Height 25 -LocationX 230 -LocationY 12 -FontName $MSSansSerif -FontSize 24
$Label4 = Create-Label -Text "Undo" -AutoSize $True -Width 230 -Height 25 -LocationX 534 -LocationY 12 -FontName $MSSansSerif -FontSize 24
$Label15 = Create-Label -Text "Windows Update" -AutoSize $True -Width 25 -Height 10 -LocationX 739 -LocationY 11 -FontName $MSSansSerif -FontSize 24
$Label16 = Create-Label -Text "I recommend doing security updates only" -AutoSize $True -Width 25 -Height 10 -LocationX 62 -LocationY 65 -FontName $MSSansSerif -FontSize 10
$Label17 = Create-Label -Text "- Delays Features updates up to 3 years" -AutoSize $True -Width 25 -Height 10 -LocationX 63 -LocationY 84 -FontName $MSSansSerif -FontSize 10
$Label18 = Create-Label -Text "- Delays security updates 4 days" -AutoSize $True -Width 25 -Height 10 -LocationX 63 -LocationY 105 -FontName $MSSansSerif -FontSize 10
$Label19 = Create-Label -Text "- Sets Maximum Active Time" -AutoSize $True -Width 25 -Height 10 -LocationX 63 -LocationY 126 -FontName $MSSansSerif -FontSize 10

# Install Buttons (In order of appearance)
$winterminal = Create-Button -Text "Windows Terminal" -Width 211 -Height 30 -LocationX 4 -LocationY 26 -FontName $MSSansSerif -FontSize 12
$powertoys = Create-Button -Text "PowerToys" -Width 211 -Height 30 -LocationX 4 -LocationY 60 -FontName $MSSansSerif -FontSize 12
$brave = Create-Button -Text "Brave Browser" -Width 212 -Height 30 -LocationX 3 -LocationY 94 -FontName $MSSansSerif -FontSize 12
$firefox = Create-Button -Text "Firefox" -Width 212 -Height 30 -LocationX 4 -LocationY 127 -FontName $MSSansSerif -FontSize 12
$gchrome = Create-Button -Text "Google Chrome" -Width 211 -Height 30 -LocationX 4 -LocationY 161 -FontName $MSSansSerif -FontSize 12
$irfanview = Create-Button -Text "Irfanview (Image Viewer)" -Width 212 -Height 30 -LocationX 3 -LocationY 195 -FontName $MSSansSerif -FontSize 12
$imageglass = Create-Button -Text "ImageGlass (Image Viewer)" -Width 212 -Height 30 -LocationX 4 -LocationY 228 -FontName $MSSansSerif -FontSize 12
$honeyview = Create-Button -Text "HoneyView (Image Viewer)" -Width 212 -Height 30 -LocationX 4 -LocationY 261 -FontName $MSSansSerif -FontSize 12
$vlc = Create-Button -Text "VLC" -Width 212 -Height 30 -LocationX 4 -LocationY 296 -FontName $MSSansSerif -FontSize 12
$mpc = Create-Button -Text "Media Player Classic" -Width 211 -Height 30 -LocationX 4 -LocationY 329 -FontName $MSSansSerif -FontSize 12
$7zip = Create-Button -Text "7-Zip" -Width 211 -Height 30 -LocationX 4 -LocationY 363 -FontName $MSSansSerif -FontSize 12
$vscode = Create-Button -Text "VS Code" -Width 211 -Height 30 -LocationX 4 -LocationY 396 -FontName $MSSansSerif -FontSize 12
$vscodium = Create-Button -Text "VS Codium" -Width 211 -Height 30 -LocationX 4 -LocationY 429 -FontName $MSSansSerif -FontSize 12
$notepad = Create-Button -Text "Notepad++" -Width 211 -Height 30 -LocationX 4 -LocationY 461 -FontName $MSSansSerif -FontSize 12
$everythingsearch = Create-Button -Text "Everything Search" -Width 211 -Height 30 -LocationX 4 -LocationY 495 -FontName $MSSansSerif -FontSize 12
$adobereader = Create-Button -Text "Adobe Reader DC" -Width 212 -Height 30 -LocationX 4 -LocationY 528 -FontName $MSSansSerif -FontSize 12
$sumatrapdf = Create-Button -Text "Sumatra PDF" -Width 212 -Height 30 -LocationX 3 -LocationY 561 -FontName $MSSansSerif -FontSize 12
$nvcleanstall = Create-Button -Text "NVCleanstall" -Width 212 -Height 30 -LocationX 4 -LocationY 592 -FontName $MSSansSerif -FontSize 12
$sdi = Create-Button -Text "SnappyDriverInstaller" -Width 212 -Height 30 -LocationX 4 -LocationY 621 -FontName $MSSansSerif -FontSize 12

# System Tweak Buttons (In order of appearance)
$essentialtweaks = Create-Button -Text "Essential Tweaks" -Width 204 -Height 75 -LocationX 4 -LocationY 25 -FontName $MSSansSerif -FontSize 14
$actioncenter = Create-Button -Text "Disable Action Center" -Width 203 -Height 30 -LocationX 4 -LocationY 105 -FontName $MSSansSerif -FontSize 12
$backgroundapps = Create-Button -Text "Disable Background Apps" -Width 205 -Height 30 -LocationX 3 -LocationY 139 -FontName $MSSansSerif -FontSize 12
$cortana = Create-Button -Text "Disable Cortana (Search)" -Width 204 -Height 30 -LocationX 4 -LocationY 174 -FontName $MSSansSerif -FontSize 12
$onedrive = Create-Button -Text "Uninstall OneDrive" -Width 204 -Height 30 -LocationX 4 -LocationY 209 -FontName $MSSansSerif -FontSize 12
$darkmode = Create-Button -Text "Dark mode" -Width 204 -Height 30 -LocationX 4 -LocationY 244 -FontName $MSSansSerif -FontSize 12
$lightmode = Create-Button -Text "Light Mode" -Width 204 -Height 30 -LocationX 4 -LocationY 279 -FontName $MSSansSerif -FontSize 12
$visualfx = Create-Button -Text "Basic Visual FX" -Width 204 -Height 30 -LocationX 4 -LocationY 313 -FontName $MSSansSerif -FontSize 12

# Undo Buttons (In order of appearance)
$essentialundo = Create-Button -Text "Undo All" -Width 211 -Height 75 -LocationX 4 -LocationY 25 -FontName $MSSansSerif -FontSize 14
$EActionCenter = Create-Button -Text "Enable Action Center" -Width 211 -Height 30 -LocationX 4 -LocationY 105 -FontName $MSSansSerif -FontSize 12
$RBackgroundApps = Create-Button -Text "Allow Background Apps" -Width 212 -Height 30 -LocationX 4 -LocationY 139 -FontName $MSSansSerif -FontSize 12
$ECortana = Create-Button -Text "Enable Cortana (Search)" -Width 212 -Height 30 -LocationX 4 -LocationY 173 -FontName $MSSansSerif -FontSize 12
$InstallOneDrive = Create-Button -Text "Install OneDrive" -Width 212 -Height 30 -LocationX 4 -LocationY 208 -FontName $MSSansSerif -FontSize 12
$HTrayIcons = Create-Button -Text "Hide Tray Icons" -Width 212 -Height 30 -LocationX 4 -LocationY 242 -FontName $MSSansSerif -FontSize 12
$EClipboardHistory = Create-Button -Text "Enable Clipboard History" -Width 212 -Height 30 -LocationX 4 -LocationY 276 -FontName $MSSansSerif -FontSize 12
$ELocation = Create-Button -Text "Enable Location Tracking" -Width 211 -Height 30 -LocationX 4 -LocationY 310 -FontName $MSSansSerif -FontSize 12
$yourphonefix = Create-Button -Text "Your Phone App Fix" -Width 211 -Height 30 -LocationX 4 -LocationY 344 -FontName $MSSansSerif -FontSize 12

# Windows Update Buttons (In order of appearance)
$defaultwindowsupdate = Create-Button -Text "Default Settings" -Width 300 -Height 30 -LocationX 24 -LocationY 26 -FontName $MSSansSerif -FontSize 14
$securitywindowsupdate = Create-Button -Text "Security Updates Only" -Width 300 -Height 30 -LocationX 24 -LocationY 142 -FontName $MSSansSerif -FontSize 14






$PictureBox1                     = New-Object system.Windows.Forms.PictureBox
$PictureBox1.width               = 412
$PictureBox1.height              = 125
$PictureBox1.location            = New-Object System.Drawing.Point(247,500)
$PictureBox1.imageLocation       = "https://github.com/ChrisTitusTech/win10script/blob/master/titus-toolbox.png?raw=true"
$PictureBox1.SizeMode            = [System.Windows.Forms.PictureBoxSizeMode]::zoom





$Form.controls.AddRange(@($Panel1,$Panel2,$Label3,$Label15,$Panel4,$PictureBox1,$Label1,$Label4,$Panel3))
$Panel1.controls.AddRange(@($brave,$firefox,$7zip,$irfanview,$adobereader,$notepad,$gchrome,$mpc,$vlc,$powertoys,$winterminal,$vscode,$Label2,$everythingsearch,$sumatrapdf,$vscodium,$imageglass,$honeyview,$nvcleanstall,$sdi))
$Panel2.controls.AddRange(@($essentialtweaks,$backgroundapps,$cortana,$actioncenter,$darkmode,$visualfx,$onedrive,$lightmode))
$Panel4.controls.AddRange(@($defaultwindowsupdate,$securitywindowsupdate,$Label16,$Label17,$Label18,$Label19))
$Panel3.controls.AddRange(@($essentialundo,$EActionCenter,$ECortana,$RBackgroundApps,$HTrayIcons,$EClipboardHistory,$ELocation,$InstallOneDrive,$yourphonefix))

$brave.Add_Click({
    Write-Host "Installing Brave Browser"
    winget install BraveSoftware.BraveBrowser | Out-Host
    if($?) { Write-Host "Installed Brave Browser" }
})

$firefox.Add_Click({
    Write-Host "Installing Firefox"
    winget install Mozilla.Firefox | Out-Host
    if($?) { Write-Host "Installed Firefox" }
})

$gchrome.Add_Click({
    Write-Host "Installing Google Chrome"
    winget install Google.Chrome | Out-Host
    if($?) { Write-Host "Installed Google Chrome" }
})

$irfanview.Add_Click({
    Write-Host "Installing Irfanview (Image Viewer)"
    winget install IrfanSkiljan.IrfanView | Out-Host
    if($?) { Write-Host "Installed Irfanview (Image Viewer)" }
})
$imageglass.Add_Click({
    Write-Host "Installing Image Glass (Image Viewer)"
    winget install DuongDieuPhap.ImageGlass | Out-Host
    if($?) { Write-Host "Installed Image Glass (Image Viewer)" }
})
$honeyview.Add_Click({
    Write-Host "Installing Bandisoft Honeyview (Image Viewer)"
    winget install Bandisoft.Honeyview | Out-Host
    if($?) { Write-Host "Installed Honeyview (Image Viewer)" }
})

$adobereader.Add_Click({
    Write-Host "Installing Adobe Reader DC"
    winget install Adobe.AdobeAcrobatReaderDC | Out-Host
    if($?) { Write-Host "Installed Adobe Reader DC" }
})

$notepad.Add_Click({
    Write-Host "Installing Notepad++"
    winget install Notepad++.Notepad++ | Out-Host
    if($?) { Write-Host "Installed Notepad++" }
})

$vlc.Add_Click({
    Write-Host "Installing VLC Media Player"
    winget install VideoLAN.VLC | Out-Host
    if($?) { Write-Host "Installed VLC Media Player" }
})

$mpc.Add_Click({
    Write-Host "Installing Media Player Classic"
    winget install clsid2.mpc-hc | Out-Host
    if($?) { Write-Host "Installed Media Player Classic" }
})

$7zip.Add_Click({
    Write-Host "Installing 7-Zip Compression Tool"
    winget install 7zip.7zip | Out-Host
    if($?) { Write-Host "Installed 7-Zip Compression Tool" }
})

$vscode.Add_Click({
    Write-Host "Installing Visual Studio Code"
    winget install Microsoft.VisualStudioCode | Out-Host
    if($?) { Write-Host "Installed Visual Studio Code" }
})

$vscodium.Add_Click({
    Write-Host "Installing VS Codium"
    winget install VSCodium.VSCodium | Out-Host
    if($?) { Write-Host "Installed VS Codium" }
})

$winterminal.Add_Click({
    Write-Host "Installing New Windows Terminal"
    winget install Microsoft.WindowsTerminal | Out-Host
    if($?) { Write-Host "Installed New Windows Terminal" }
})

$powertoys.Add_Click({
    Write-Host "Installing Microsoft PowerToys"
    winget install Microsoft.PowerToys | Out-Host
    if($?) { Write-Host "Installed Microsoft PowerToys" }
})

$everythingsearch.Add_Click({
    Write-Host "Installing Voidtools Everything Search"
    winget install voidtools.Everything | Out-Host
    if($?) { Write-Host "Installed Everything Search" }
})

$sumatrapdf.Add_Click({
    Write-Host "Installing Sumatra PDF"
    winget install SumatraPDF.SumatraPDF | Out-Host
    if($?) { Write-Host "Installed Sumatra PDF" }
})

$nvcleanstall.Add_Click({
    Write-Host "Download NVCleanstall for NvidiaDrivers"
    # Put the URL on my own Upload Server, since NVCleanstall is hosted via Techpowerup and they dont have Permalinks
    $url = "https://files.thicc-thighs.de/?r=/download&path=L1NjcmlwdHMvTnZDbGVhbnN0YWxsLmV4ZQ%3D%3D"
    $output = "$PSScriptRoot/dump/NVCleanstall_1.10.0.exe"
    Invoke-WebRequest -Uri $url -OutFile $output
    Start-Process -FilePath $output
})

$sdi.Add_Click({
    Write-Host "Downloading SnappyDriverInstaller"
    $url = "https://sdi-tool.org/releases/SDI_R2102.zip"
    $output = "$PSScriptRoot/dump/sdi.zip"
    New-Item -ItemType directory -Path "$PSScriptRoot/dump/sdi"
    Invoke-WebRequest -Uri $url -OutFile $output
    Expand-Archive "$PSScriptRoot/dump/sdi.zip" -DestinationPath "$PSScriptRoot/dump/sdi"
    Start "$PSScriptRoot/dump/sdi"
})

$openshell.Add_Click({
    Write-Host "Installing OpenShell (Old Windows menu)"
    winget install openshellmenu | Out-Host
    Write-Host "Installed OpenShell"
})

$essentialtweaks.Add_Click({
    Write-Host "Creating Restore Point incase something bad happens"
    Enable-ComputerRestore -Drive "C:\"
    Checkpoint-Computer -Description "RestorePoint1" -RestorePointType "MODIFY_SETTINGS"

    Write-Host "Running O&O Shutup with Recommended Settings"
    Import-Module BitsTransfer
    Start-BitsTransfer -Source "https://raw.githubusercontent.com/ChrisTitusTech/win10script/master/ooshutup10.cfg" -Destination ooshutup10.cfg
    Start-BitsTransfer -Source "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -Destination OOSU10.exe
    ./OOSU10.exe ooshutup10.cfg /quiet

    Write-Host "Disabling Telemetry..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null
    Write-Host "Disabling Application suggestions..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1
    Write-Host "Disabling Activity History..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type DWord -Value 0
    Write-Host "Disabling Location Tracking..."
    If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Deny"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0
    Write-Host "Disabling automatic Maps updates..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0
    Write-Host "Disabling Feedback..."
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
    Write-Host "Disabling Tailored Experiences..."
    If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
        New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1
    Write-Host "Disabling Advertising ID..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1
    Write-Host "Disabling Error reporting..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" | Out-Null
    Write-Host "Restricting Windows Update P2P only to local network..."
    If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Type DWord -Value 1
    Write-Host "Stopping and disabling Diagnostics Tracking Service..."
    Stop-Service "DiagTrack" -WarningAction SilentlyContinue
    Set-Service "DiagTrack" -StartupType Disabled
    Write-Host "Stopping and disabling WAP Push Service..."
    Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
    Set-Service "dmwappushservice" -StartupType Disabled
    Write-Host "Enabling F8 boot menu options..."
    bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
    Write-Host "Stopping and disabling Home Groups services..."
    Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue
    Set-Service "HomeGroupListener" -StartupType Disabled
    Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue
    Set-Service "HomeGroupProvider" -StartupType Disabled
    Write-Host "Disabling Remote Assistance..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 0
    Write-Host "Disabling Storage Sense..."
    Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" -Recurse -ErrorAction SilentlyContinue
    Write-Host "Stopping and disabling Superfetch service..."
    Stop-Service "SysMain" -WarningAction SilentlyContinue
    Set-Service "SysMain" -StartupType Disabled
    Write-Host "Setting BIOS time to UTC..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 1
    Write-Host "Disabling Hibernation..."
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernteEnabled" -Type Dword -Value 0
    If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Type Dword -Value 0
    Write-Host "Showing task manager details..."
    $taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
    Do {
        Start-Sleep -Milliseconds 100
        $preferences = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -ErrorAction SilentlyContinue
    } Until ($preferences)
    Stop-Process $taskmgr
    $preferences.Preferences[28] = 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -Type Binary -Value $preferences.Preferences
    Write-Host "Showing file operations details..."
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWord -Value 1
    Write-Host "Hiding Task View button..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
    Write-Host "Hiding People icon..."
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 0
    Write-Host "Showing all tray icons..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Type DWord -Value 0
    Write-Host "Enabling NumLock after startup..."
    If (!(Test-Path "HKU:")) {
        New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null
    }
    Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2147483650
    Add-Type -AssemblyName System.Windows.Forms
    If (!([System.Windows.Forms.Control]::IsKeyLocked('NumLock'))) {
        $wsh = New-Object -ComObject WScript.Shell
        $wsh.SendKeys('{NUMLOCK}')
    }

    Write-Host "Changing default Explorer view to This PC..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
    Write-Host "Hiding 3D Objects icon from This PC..."
    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue

	# Network Tweaks
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "IRPStackSize" -Type DWord -Value 20

	# SVCHost Tweak
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value 4194304

    #Write-Host "Installing Windows Media Player..."
	#Enable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer" -NoRestart -WarningAction SilentlyContinue | Out-Null

    Write-Host "Essential Tweaks Completed"
})

$essentialundo.Add_Click({
    Write-Host "Creating Restore Point incase something bad happens"
    Enable-ComputerRestore -Drive "C:\"
    Checkpoint-Computer -Description "RestorePoint1" -RestorePointType "MODIFY_SETTINGS"

    Write-Host "Enabling Telemetry..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 1
    Write-Host "Enabling Application suggestions..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 1
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
        Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Recurse -ErrorAction SilentlyContinue
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 0
    Write-Host "Enabling Activity History..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type DWord -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type DWord -Value 1
    Write-Host "Enable Location Tracking..."
    If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
        Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Recurse -ErrorAction SilentlyContinue
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Allow"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 1
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 1
    Write-Host "Enabling automatic Maps updates..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 1
    Write-Host "Enabling Feedback..."
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
        Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Recurse -ErrorAction SilentlyContinue
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 0
    Write-Host "Enabling Tailored Experiences..."
    If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
        Remove-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Recurse -ErrorAction SilentlyContinue
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 0
    Write-Host "Disabling Advertising ID..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
        Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Recurse -ErrorAction SilentlyContinue
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 0
    Write-Host "Allow Error reporting..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 0
    Write-Host "Allowing Diagnostics Tracking Service..."
    Stop-Service "DiagTrack" -WarningAction SilentlyContinue
    Set-Service "DiagTrack" -StartupType Manual
    Write-Host "Allowing WAP Push Service..."
    Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
    Set-Service "dmwappushservice" -StartupType Manual
    Write-Host "Allowing Home Groups services..."
    Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue
    Set-Service "HomeGroupListener" -StartupType Manual
    Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue
    Set-Service "HomeGroupProvider" -StartupType Manual
    Write-Host "Enabling Storage Sense..."
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" | Out-Null
    Write-Host "Allowing Superfetch service..."
    Stop-Service "SysMain" -WarningAction SilentlyContinue
    Set-Service "SysMain" -StartupType Manual
    Write-Host "Setting BIOS time to Local Time instead of UTC..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 0
    Write-Host "Enabling Hibernation..."
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernteEnabled" -Type Dword -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Type Dword -Value 1
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -ErrorAction SilentlyContinue

    Write-Host "Hiding file operations details..."
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager")) {
        Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Recurse -ErrorAction SilentlyContinue
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWord -Value 0
    Write-Host "Showing Task View button..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 1
    Write-Host "Hiding tray icons..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Type DWord -Value 1


    Write-Host "Changing default Explorer view to Quick Access..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 0

    Write-Host "Essential Undo Completed"
})

$windowssearch.Add_Click({
    Write-Host "Disabling Bing Search in Start Menu..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -Type DWord -Value 0
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -Type DWord -Value 1
    Write-Host "Stopping and disabling Windows Search indexing service..."
    Stop-Service "WSearch" -WarningAction SilentlyContinue
    Set-Service "WSearch" -StartupType Disabled
    Write-Host "Hiding Taskbar Search icon / box..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
    Write-Host "Search tweaks completed"
})

$backgroundapps.Add_Click({
    Write-Host "Disabling Background application access..."
    Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Exclude "Microsoft.Windows.Cortana*" | ForEach {
        Set-ItemProperty -Path $_.PsPath -Name "Disabled" -Type DWord -Value 1
        Set-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -Type DWord -Value 1
    }
    Write-Host "Disabled Background application access"
})

$cortana.Add_Click({
    Write-Host "Disabling Cortana..."
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 1
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value 0
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Type DWord -Value 0
    Write-Host "Disabled Cortana"
})

$defaultwindowsupdate.Add_Click({
    Write-Host "Enabling driver offering through Windows Update..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontPromptForWindowsUpdate" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontSearchWindowsUpdate" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DriverUpdateWizardWuSearchEnabled" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "ExcludeWUDriversInQualityUpdate" -ErrorAction SilentlyContinue
    Write-Host "Enabling Windows Update automatic restart..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUPowerManagement" -ErrorAction SilentlyContinue
    Write-Host "Enabled driver offering through Windows Update"
})

$securitywindowsupdate.Add_Click({
    Write-Host "Disabling driver offering through Windows Update..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -Type DWord -Value 1
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontPromptForWindowsUpdate" -Type DWord -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontSearchWindowsUpdate" -Type DWord -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DriverUpdateWizardWuSearchEnabled" -Type DWord -Value 0
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "ExcludeWUDriversInQualityUpdate" -Type DWord -Value 1
    Write-Host "Disabling Windows Update automatic restart..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Type DWord -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUPowerManagement" -Type DWord -Value 0
    Write-Host "Disabled driver offering through Windows Update"
})

$actioncenter.Add_Click({
    Write-Host "Disabling Action Center..."
    If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer")) {
        New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Type DWord -Value 0
    Write-Host "Disabled Action Center"
})

$visualfx.Add_Click({
    Write-Host "Adjusting visual effects for performance..."
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type String -Value 0
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type String -Value 200
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Type Binary -Value ([byte[]](144,18,3,128,16,0,0,0))
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Type String -Value 0
    Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Type DWord -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Type DWord -Value 3
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "EnableAeroPeek" -Type DWord -Value 0
    Write-Host "Adjusted visual effects for performance"
})

$onedrive.Add_Click({
    Write-Host "Disabling OneDrive..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1
    Write-Host "Uninstalling OneDrive..."
    Stop-Process -Name "OneDrive" -ErrorAction SilentlyContinue
    Start-Sleep -s 2
    $onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
    If (!(Test-Path $onedrive)) {
        $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
    }
    Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
    Start-Sleep -s 2
    Stop-Process -Name "explorer" -ErrorAction SilentlyContinue
    Start-Sleep -s 2
    Remove-Item -Path "$env:USERPROFILE\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse -ErrorAction SilentlyContinue
    If (!(Test-Path "HKCR:")) {
        New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
    }
    Remove-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
    Write-Host "Disabled OneDrive"
})

$darkmode.Add_Click({
    Write-Host "Enabling Dark Mode"
    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0
    Write-Host "Enabled Dark Mode"
})

$lightmode.Add_Click({
    Write-Host "Switching Back to Light Mode"
    Remove-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme
    Write-Host "Switched Back to Light Mode"
})

$EActionCenter.Add_Click({
    Write-Host "Enabling Action Center..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -ErrorAction SilentlyContinue
	Write-Host "Done - Reverted to Stock Settings"
})

$ECortana.Add_Click({
    Write-Host "Enabling Cortana..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -ErrorAction SilentlyContinue
	If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) {
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 0
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -ErrorAction SilentlyContinue
	Write-Host "Restoring Windows Search..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value "1"
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -ErrorAction SilentlyContinue
	Write-Host "Restore and Starting Windows Search Service..."
    Set-Service "WSearch" -StartupType Automatic
    Start-Service "WSearch" -WarningAction SilentlyContinue
    Write-Host "Restore Windows Search Icon..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 1
	Write-Host "Done - Reverted to Stock Settings"
})

$HTrayIcons.Add_Click({
	Write-Host "Hiding tray icons..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -ErrorAction SilentlyContinue
	Write-Host "Done - Reverted to Stock Settings"
})

$EClipboardHistory.Add_Click({
	Write-Host "Restoring Clipboard History..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Clipboard" -Name "EnableClipboardHistory" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "AllowClipboardHistory" -ErrorAction SilentlyContinue
	Write-Host "Done - Reverted to Stock Settings"
})

$ELocation.Add_Click({
	Write-Host "Enabling Location Provider..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" -Name "DisableWindowsLocationProvider" -ErrorAction SilentlyContinue
	Write-Host "Enabling Location Scripting..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" -Name "DisableLocationScripting" -ErrorAction SilentlyContinue
	Write-Host "Enabling Location..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" -Name "DisableLocation" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "Value" -Type String -Value "Allow"
	Write-Host "Allow access to Location..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Allow"
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value "1"
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessLocation" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessLocation_UserInControlOfTheseApps" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessLocation_ForceAllowTheseApps" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessLocation_ForceDenyTheseApps" -ErrorAction SilentlyContinue
	Write-Host "Done - Reverted to Stock Settings"
})

$RBackgroundApps.Add_Click({
	Write-Host "Allowing Background Apps..."
	Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Exclude "Microsoft.Windows.Cortana*" | ForEach {
		Remove-ItemProperty -Path $_.PsPath -Name "Disabled" -ErrorAction SilentlyContinue
		Remove-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -ErrorAction SilentlyContinue
	}
	Write-Host "Done - Reverted to Stock Settings"
})

$EHibernation.Add_Click({
    Write-Host "Enabling Hibernation"
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernteEnabled" -Type Dword -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Type Dword -Value 1
    Write-Host "Done - Reverted to Stock Settings"
})

$InstallOneDrive.Add_Click({
    Write-Host "Installing Onedrive. Please Wait..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -ErrorAction SilentlyContinue
    %systemroot%\SysWOW64\OneDriveSetup.exe
})

$DisableNumLock.Add_Click({
    Write-Host "Disable NumLock after startup..."
    Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 0
    Add-Type -AssemblyName System.Windows.Forms
    If (([System.Windows.Forms.Control]::IsKeyLocked('NumLock'))) {
        $wsh = New-Object -ComObject WScript.Shell
        $wsh.SendKeys('{NUMLOCK}')
    }
})

$yourphonefix.Add_Click({
    Write-Host "Enable needed data collection for Your Phone..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableMmx" -Type DWord -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableCdp" -Type DWord -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Messaging" -Name "AllowMessageSync" -Type DWord -Value 1
    Write-Host "Allowing Background Apps..."
	Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Exclude "Microsoft.Windows.Cortana*" | ForEach {
		Remove-ItemProperty -Path $_.PsPath -Name "Disabled" -ErrorAction SilentlyContinue
		Remove-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -ErrorAction SilentlyContinue
	}
    Write-Host "You may need to Reboot and right-click Your Phone app and select repair"
})

[void]$Form.ShowDialog()