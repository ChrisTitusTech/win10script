[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")
[void] [System.Windows.Forms.Application]::EnableVisualStyles()

$ErrorActionPreference = 'SilentlyContinue'
$wshell = New-Object -ComObject Wscript.Shell
$Button = [System.Windows.MessageBoxButton]::YesNoCancel
$ErrorIco = [System.Windows.MessageBoxImage]::Error
$Ask = 'Do you want to run this as an Administrator?
        Select "Yes" to Run as an Administrator
        Select "No" to not run this as an Administrator
        
        Select "Cancel" to stop the script.'

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    $Prompt = [System.Windows.MessageBox]::Show($Ask, "Run as an Administrator or not?", $Button, $ErrorIco) 
    Switch ($Prompt) {
        #This will debloat Windows 10
        Yes {
            Write-Host "You didn't run this script as an Administrator. This script will self elevate to run as an Administrator and continue."
            Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
            Exit
        }
        No {
            Break
        }
    }
}

# GUI Specs
$objForm                         = New-Object System.Windows.Forms.Form
$objForm.Text                    = "Windows 10 Debloat By Chris Titus"
$objForm.Size                    = New-Object System.Drawing.Size(1050,700)
$objForm.StartPosition           = "CenterScreen"
$objForm.KeyPreview              = $True
$objForm.MaximumSize             = $objForm.Size
$objForm.MinimumSize             = $objForm.Size

# GUI Icon
$iconBase64                      = 'AAABAAMAMDAAAAEAIACoJQAANgAAACAgAAABACAAqBAAAN4lAAAQEAAAAQAgAGgEAACGNgAAKAAAADAAAABgAAAAAQAgAAAAAAAAJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEZGRgKxsbEBR0dHAq+vrwEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///8C////Dt3d3Sm/v785wMDAOsDAwDrAwMA6wMDAOsDAwDrBwcE7wMDAPa6urjzm5uYV////AQAAAAAAAAAAAAAAAAAAAAD///8C3NzcIFNTU3O+vr5NVFRUdLy8vCj///8DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////Af///wv///8R////BQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///wL///8Xv7+/WYWFhaSPj4+vjo6OrY6Ojq2Ojo6tjo6OrY+Pj62Ojo6wh4eHqGxsbJfMzMwu////AwAAAAAAAAAAAAAAAP///wH///8O8PDwRnZ2dqnU1NRvdHR0ntLS0jn///8EAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////BqmpqUF7e3tu////GP///wEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////Af///w67u7tXiIiIua2trcecnJzEnJycwJubm7+bm5u/m5ubv52dncCKiorItra2m/X19Vf39/cg////AwAAAAAAAAAAAAAAAP///wPU1NQuhISEnn9/f7jX19dodnZ2ltPT0zX///8DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////B6mpqVZ7e3uc////Mf///wgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///wv///8J////CNjY2Dd8fHyonJycy5ycnM+mpqbSkJCQ2I6OjteOjo7Xjo6O2IuLi9KFhYXFgICAs2hoaKGvr68+////BQAAAAAAAAAAAAAAAP///wPc3Nw1hISEsISEhL/X19drd3d3l9PT0zX///8DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////B7W1tVGFhYW2jIyMhvX19R3///8BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJSUlGW8vLxZ7e3tQNHR0WtfX1/UlJSUz6GhocyJiYnci4uLzYaGhryGhoa7fX19wYGBganU1NRZxsbGRbS0tEXa2toe////AwAAAAAAAAAAAAAAAP///wXi4uI2jIyMrImJicbKysqUf39/ptXV1Tb///8DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////B7W1tVCHh4fDf39/pfz8/CT///8CAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFpaWsdra2vQeXl5wYqKisBvb2/dmpqa0ZycnM5qamrcxcXFjfX19Vbj4+Ni6enpX+bm5kX///8a////C////wj///8E////AQAAAAAAAAAA////Au7u7hnAwMBokpKSuI+Pj9OEhITSeHh4u9vb2zj///8DAAAAAAAAAAAAAAAAAAAAAAAAAAD///8B////Cri4uFWJiYnBiIiInf///yH///8BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKqqqmOYmJiHhYWFpnt7e8BwcHDYampq34SEhNppaWnhkJCQs7GxsZF1dXWzhISEqp+fn4i3t7dm1tbWR/X19S7///8d////Ev///wj///8C////A9ra2jN0dHS0k5OTyZKSktSVlZXQf39/utnZ2Tj///8DAAAAAAAAAAAAAAAAAAAAAAAAAAD///8E29vbKqqqqoaOjo7HiIiInv///yP///8DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///wv///8V/f39JPX19UKSkpKbDw8P+BQUFPhoaGjVd3d3yGxsbNJoaGjdbGxs4m5ubuBwcHDZdnZ2y4CAgLWRkZGalZWVgb+/v0X///8P////B+fn5zKJiYmvl5eXy5GRkdOVlZXOfn5+utnZ2Tj///8EAAAAAAAAAAAAAAAAAAAAAAAAAAD///8HrKysU3Nzc8uUlJTOkZGRreXl5Un5+fkQ////AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///8B////Av///xGKiop+CwsL+goKCvyWlpaY7u7uT7y8vF+goKB/i4uLnnt7e7lxcXHNbW1t2mxsbOFubm7iZGRk4JKSkqrHx8dh5OTkQPDw8FGNjY20l5eXypGRkdOVlZXNgoKCvuLi4kj///8Q////Bv///wP///8BAAAAAAAAAAD///8GvLy8T4KCgsuWlpbQkJCQyHl5eaPl5eUp////AgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////Af///w6IiIh8CwsL+goKCvyFhYWC////FP///wr///8S////H/Hx8TLR0dFLsbGxapaWloqCgoKoc3NzwGdnZ85iYmLOaWlpwn9/f7uDg4PPnZ2dzZOTk9WXl5fPhYWF0JSUlKOxsbFr0dHRR/Ly8i3///8b////D////wj///8Ju7u7T4GBgcqWlpbPlpaWy4mJiafv7+8s////AwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///w6IiIh8CwsL+goKCvyDg4OA////EP///wH///8B////Af///wP///8G////DP///xb+/v4l6OjoOsXFxVWlpaV0ioqKlHNzc7F5eXnHampq2m5ubuSJiYnZgoKC3319feKIiIjYiIiIyYuLi7OVlZWVqampc8bGxlPv7+89zc3NbIODg86WlpbPlpaWypCQkKv09PQ6////BgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///w6IiIh8CwsL+goKCvyDg4OA////EAAAAAAAAAAAAAAAAAAAAAAAAAAA////Af///wH///8C////BP///wj///8P////Gvr6+izn5+dbRUVF0wYGBv8yMjLth4eHyXl5ec54eHjae3t74IGBgeKEhIThhISE3IWFhdCDg4PCi4uLx4uLi9uWlpbQmZmZy3h4eMmMjIx9////FP///wEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///w6IiIh7CwsL+goKCvyFhYWD////EQAAAAAAAAAAAAAAAAAAAAD///8D////CP///wj///8F////AQAAAAAAAAAA////Af///wT///8sQUFBxQAAAP8xMTHf6OjoZtLS0k+wsLBrl5eXi4WFhal5eXnBdHR003Z2dt13d3fid3d35IqKiuGZmZnTnZ2dzXd3d9aPj4+f////NP///xX///8L////Bv///wP///8B////AQAAAAAAAAAAAAAAAP///wySkpJzDg4O+AcHB/55eXmV////Gf///wEAAAAAAAAAAP///wXj4+MopqamW56enmK4uLg7////CQAAAAAAAAAAAAAAAP///wL///8pQEBAxAEBAf8sLCzZ5ubmPv///wr///8M////Fv39/Sbl5eU7xMTEV6ampnaPj4+Wf39/s319fcxhYWHidnZ23Xx8fNuEhITPkJCQp5ubm4WxsbFmzs7OSO7u7jD///8e////EgAAAAAAAAAAAAAAAP///wm1tbVcGRkZ7QICAv9OTk7D////Ov///wj///8C////BP///x6QkJCEGRkZ7RQUFPNycnKF////Ef///wH///8B////Af///wP///8qQEBAxAEBAf8sLCzZ5eXlPP///wX///8C////Av///wP///8E////Cf///xD///8c/Pz8MczMzHElJSXnBwcH/k5OTt+RkZHBgoKCyoCAgNOAgIDSgoKCx4eHh7SLi4ucjY2NdwAAAAAAAAAAAAAAAP///wTz8/M4PT09ygEBAf8UFBTzj4+PlP///zr///8f////Lru7u3MwMDDeAQEB/xwcHOu0tLRh////Df///xD///8b////Hf///x////9BR0dHygAAAP8wMDDd7OzsUv///yH///8e////HP///xP///8J////FP///x3///8f////JN3d3V8mJibkAAAA/2NjY8b///9p4+PjasbGxoevr6+ilZWVs4WFhcB6enrOeHh4tgAAAAAAAAAAAAAAAP///wH///8Xk5OTgBQUFPMBAQH/FRUV809PT8NwcHCjXFxctyIiIugDAwP/CQkJ/GZmZqj///8q////EIyMjGBRUVGrVFRUrVRUVK5hYWG6LCws6wEBAf8fHx/yYGBgwFVVVa9UVFSuUFBQrXt7e3T///8tc3NzfVFRUa1UVFSuVlZWr15eXsMZGRn0AgIC/zU1NeViYmK6W1tbtGFhYbhnZ2e7ubm5eerq6kW8vLxUpqamVwAAAAAAAAAAAAAAAAAAAAD///8F/Pz8L3Nzc50VFRXyAgIC/wEBAf8EBAT/AgIC/wEBAf8NDQ35VVVVuOLi4kX///8L////FWFhYZgDAwP/AgIC/wICAv8BAQH/AgIC/wICAv8CAgL/AQEB/wICAv8CAgL/AQEB/0hISLX///9IPDw8wQAAAP8CAgL/AgIC/wEBAf8CAgL/AgIC/wEBAf8BAQH/AQEB/wEBAf8FBQX+dXV1hv///xT///8I////CAAAAAAAAAAAAAAAAAAAAAAAAAAA////CPn5+S6ampp6RkZGwCQkJOIaGhrsHx8f5js7O8uDg4OM6urqPP///w3///8C////EHV1dXwqKirYKysr2SsrK9krKyvZKysr2SsrK9krKyvZKysr2SsrK9krKyvZKCgo2mBgYJX///85VlZWoCgoKNorKyvZKysr2SsrK9krKyvZKysr2SsrK9krKyvZKysr2SsrK9ksLCzWhYWFbf///w3///8BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///wT///8T9/f3K83NzUK0tLRMw8PDRu/v7zH///8X////Bv///wEAAAAA////Benp6R7f39814eHhOOHh4Tjh4eE44eHhOOHh4Tjh4eE44eHhOOHh4Tjh4eE439/fNuXl5ST///8Q5OTkJ9/f3zfh4eE44eHhOOHh4Tjh4eE44eHhOOHh4Tjh4eE44eHhOOHh4Tjf39806+vrG////wQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP///////wAA////////AAD///////8AAP///////wAA////////AAD///////8AAP///////wAA////////AAD///////8AAP///////wAA////////AAD///////8AAP///////wAA////////AAD///////8AAPwA/1///wAA+AH+X/v/AADwAP5f+f8AAPAH/h/5/wAAAH/+H/n/AACAB/wf8f8AAPAAPB/x/wAA+OAcH/D/AAD4/gAP8P8AAPj/8ADw/wAA+P/+AAD/AAD4//44AH8AAPj//j/AHwAA+Ph+P/gBAAD4eP4/+MAAAPgA4AOADwAA/AHAAQAHAAD/A+ABAA8AAP///////wAA////////AAD///////8AAP///////wAA////////AAD///////8AAP///////wAA////////AAD///////8AAP///////wAA////////AAD///////8AAP///////wAA////////AAD///////8AACgAAAAgAAAAQAAAAAEAIAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD29vYJubm5JK6uri2vr68tr6+vLbCwsC2srKwvo6OjJv///wQAAAAAAAAAAAAAAACtra0Td3d3RHt7e0Senp4YAAAAAAAAAAAAAAAAAAAAAP///wHq6uoM7u7uBwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/v7+DKqqql+YmJiql5eXrZaWlqyWlpaslZWVr5WVlaWfn59j////CwAAAAAAAAAA////BbCwsE+RkZGVlJSUhbKysi8AAAAAAAAAAAAAAAAAAAAA////BoyMjFioqKg5////AQAAAAAAAAAAAAAAAAAAAAAAAAAA////Cf///waqqqpIj4+PvKOjo8+WlpbSkJCQ0pCQkNKOjo7Lj4+Pr5mZmWzp6ekPAAAAAAAAAAD///8NjIyMjJSUlKSZmZmAs7OzLAAAAAAAAAAAAAAAAAAAAAD///8GlZWVcJeXl4Hi4uITAAAAAAAAAAAAAAAAAAAAAAAAAAB9fX2DpKSkbY6Ojp2FhYXUlpaW0o+Pj8OcnJydlZWVoKCgoHbBwcE7qKioLu7u7gcAAAAAAAAAAPn5+Rebm5uRlZWVv5CQkKO7u7stAAAAAAAAAAAAAAAAAAAAAP///waZmZlzh4eHq9bW1h8AAAAAAAAAAAAAAAAAAAAAAAAAAIGBgYyBgYGqfHx8xnV1ddt4eHjdiIiIuKysrIiUlJSUr6+vasPDwz7n5+cj/v7+Ev///wX///8BoqKiTI6Ojr6SkpLUhISEvcPDwy4AAAAAAAAAAAAAAAAAAAAA3d3dG5qampCNjY2n3NzcHgAAAAAAAAAAAAAAAAAAAAAAAAAA////DPDw8BvGxsZRKysr3iwsLOqKioqre3t7tHFxcc5xcXHWdHR0z319fbuBgYGfs7OzUf///xasrKxckZGRyJSUlNGJiYm6xMTEMAAAAAAAAAAAAAAAAAAAAACqqqo/hoaGxpOTk7uwsLBQ////BQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAM7OzioiIiLZIiIi3djY2Dzk5OQivr6+PqSkpF+Pj4+EgICAqHR0dMN3d3e8f39/n4qKiqqSkpLOlpaW0oyMjMmkpKR9v7+/P9/f3yL9/f0P////BbGxsT+Li4vHk5OTzpKSkoP///8LAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAz8/PKyIiItkgICDcysrKLAAAAAAAAAAA////Av///wn39/cW09PTK66urkmUlJRsiYmJkWxsbMtUVFToe3t73X5+ft2GhobQi4uLuZSUlJekpKRxqqqqfo2Njc2VlZXNlpaWluDg4BoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADPz88qIiIi2SEhIdzLy8suAAAAAAAAAAD///8B////Bf///wb///8BAAAAAP///wT///8UVlZWngsLC/5/f3+foaGheYuLi5yCgoK7fn5+0Xx8fNt6enrfjIyM3JmZmc98fHzGvr6+Tf///xD///8G////AQAAAAAAAAAAAAAAAODg4CQoKCjQGxsb6ba2tkMAAAAAAAAAAOrq6hhqampzXV1df8LCwh8AAAAAAAAAAP///whPT0+WDAwM/XZ2dmr///8H/f39EN7e3iO6uro+o6OjYJSUlIV3d3fATk5O6HNzc9mLi4u4kJCQlpycnHWurq5Surq6NQAAAAAAAAAA////E0hISKkKCgr+ZGRkmvf39yr///8ihISEehQUFPMvLy/M3d3dJ////xD///8Z////IltbW6ENDQ39hoaGeP///xv///8Y////Df///w7///8c////JoGBgYoKCgr9cXFxury8vImjo6Ook5OTuoaGhr19fX2uAAAAAAAAAAD///8DmpqaVB8fH+QODg74NDQ0zTk5OcYTExPzFRUV8H5+fnD///8WVVVVhi4uLsY0NDTGJSUl5wYGBv4uLi7dMjIyxS8vL8R8fHxsc3Nzci8vL8QyMjLFLCws3gUFBf4pKSnkOjo6yTs7O9F1dXWY1dXVP6qqqkQAAAAAAAAAAAAAAAD///8Ojo6OYTY2NsMYGBjpFhYW7C4uLsx9fX1y/Pz8FP///xBISEicHBwc5R0dHeIdHR3gHx8f3x0dHeEdHR3iHh4e4nJycn1oaGiFHR0d4x0dHeIdHR3hHx8f3x0dHeAdHR3iHBwc5E5OTpD///8LAAAAAAAAAAAAAAAAAAAAAAAAAAD///8G39/fHqKiojacnJw41dXVIv///wgAAAAA////A8HBwR62trYtuLi4Lbi4uC24uLgtuLi4Lbi4uC22trYsz8/PGMzMzBq2trYtuLi4Lbi4uC24uLgtuLi4Lbi4uC22trYtw8PDHP///wIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA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'
$iconBytes                       = [Convert]::FromBase64String($iconBase64)
$stream                          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length)
$objForm.Icon                    = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

$objForm.Width                   = $objImage.Width
$objForm.Height                  = $objImage.Height

$objPanel1                       = New-Object system.Windows.Forms.Panel
$objPanel1.height                = 156
$objPanel1.width                 = 1032
$objPanel1.location              = New-Object System.Drawing.Point(9,90)

$objLabel1                       = New-Object system.Windows.Forms.Label
$objLabel1.text                  = "Program Installation"
$objLabel1.AutoSize              = $true
$objLabel1.width                 = 25
$objLabel1.height                = 10
$objLabel1.location              = New-Object System.Drawing.Point(10,30)
$objLabel1.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',30)

$installchoco                    = New-Object system.Windows.Forms.Button
$installchoco.text               = "Install Chocolatey"
$installchoco.width              = 200
$installchoco.height             = 115
$installchoco.location           = New-Object System.Drawing.Point(16,19)
$installchoco.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',16)

$brave                           = New-Object system.Windows.Forms.Button
$brave.text                      = "Brave Browser"
$brave.width                     = 150
$brave.height                    = 30
$brave.location                  = New-Object System.Drawing.Point(250,19)
$brave.Font                      = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$firefox                         = New-Object system.Windows.Forms.Button
$firefox.text                    = "Firefox"
$firefox.width                   = 150
$firefox.height                  = 30
$firefox.location                = New-Object System.Drawing.Point(250,61)
$firefox.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$7zip                            = New-Object system.Windows.Forms.Button
$7zip.text                       = "7-Zip"
$7zip.width                      = 150
$7zip.height                     = 30
$7zip.location                   = New-Object System.Drawing.Point(584,104)
$7zip.Font                       = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$irfanview                       = New-Object system.Windows.Forms.Button
$irfanview.text                  = "Irfanview"
$irfanview.width                 = 150
$irfanview.height                = 30
$irfanview.location              = New-Object System.Drawing.Point(417,19)
$irfanview.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$adobereader                     = New-Object system.Windows.Forms.Button
$adobereader.text                = "Adobe Reader DC"
$adobereader.width               = 150
$adobereader.height              = 30
$adobereader.location            = New-Object System.Drawing.Point(417,61)
$adobereader.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$notepad                         = New-Object system.Windows.Forms.Button
$notepad.text                    = "Notepad++"
$notepad.width                   = 150
$notepad.height                  = 30
$notepad.location                = New-Object System.Drawing.Point(417,104)
$notepad.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$gchrome                         = New-Object system.Windows.Forms.Button
$gchrome.text                    = "Google Chrome"
$gchrome.width                   = 150
$gchrome.height                  = 30
$gchrome.location                = New-Object System.Drawing.Point(250,104)
$gchrome.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$mpc                             = New-Object system.Windows.Forms.Button
$mpc.text                        = "Media Player Classic"
$mpc.width                       = 150
$mpc.height                      = 30
$mpc.location                    = New-Object System.Drawing.Point(584,61)
$mpc.Font                        = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$vlc                             = New-Object system.Windows.Forms.Button
$vlc.text                        = "VLC"
$vlc.width                       = 150
$vlc.height                      = 30
$vlc.location                    = New-Object System.Drawing.Point(584,19)
$vlc.Font                        = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$powertoys                       = New-Object system.Windows.Forms.Button
$powertoys.text                  = "PowerToys"
$powertoys.width                 = 150
$powertoys.height                = 30
$powertoys.location              = New-Object System.Drawing.Point(751,105)
$powertoys.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$winterminal                     = New-Object system.Windows.Forms.Button
$winterminal.text                = "Windows Terminal"
$winterminal.width               = 150
$winterminal.height              = 30
$winterminal.location            = New-Object System.Drawing.Point(751,61)
$winterminal.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$vscode                          = New-Object system.Windows.Forms.Button
$vscode.text                     = "VS Code"
$vscode.width                    = 150
$vscode.height                   = 30
$vscode.location                 = New-Object System.Drawing.Point(751,19)
$vscode.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$objLabel2                       = New-Object system.Windows.Forms.Label
$objLabel2.text                  = "(Chocolatey Required for installs)"
$objLabel2.AutoSize              = $true
$objLabel2.width                 = 25
$objLabel2.height                = 10
$objLabel2.location              = New-Object System.Drawing.Point(478,3)
$objLabel2.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$objPanel2                       = New-Object system.Windows.Forms.Panel
$objPanel2.height                = 159
$objPanel2.width                 = 588
$objPanel2.location              = New-Object System.Drawing.Point(9,293)

$objLabel3                       = New-Object system.Windows.Forms.Label
$objLabel3.text                  = "System Tweaks"
$objLabel3.AutoSize              = $true
$objLabel3.width                 = 230
$objLabel3.height                = 25
$objLabel3.location              = New-Object System.Drawing.Point(195,251)
$objLabel3.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',24)

$essentialtweaks                 = New-Object system.Windows.Forms.Button
$essentialtweaks.text            = "Essential Tweaks"
$essentialtweaks.width           = 200
$essentialtweaks.height          = 115
$essentialtweaks.location        = New-Object System.Drawing.Point(24,34)
$essentialtweaks.Font            = New-Object System.Drawing.Font('Microsoft Sans Serif',14)

$backgroundapps                  = New-Object system.Windows.Forms.Button
$backgroundapps.text             = "Background Apps"
$backgroundapps.width            = 150
$backgroundapps.height           = 30
$backgroundapps.location         = New-Object System.Drawing.Point(251,45)
$backgroundapps.Font             = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$cortana                         = New-Object system.Windows.Forms.Button
$cortana.text                    = "Cortana"
$cortana.width                   = 150
$cortana.height                  = 30
$cortana.location                = New-Object System.Drawing.Point(251,82)
$cortana.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$windowssearch                   = New-Object system.Windows.Forms.Button
$windowssearch.text              = "Windows Search"
$windowssearch.width             = 150
$windowssearch.height            = 30
$windowssearch.location          = New-Object System.Drawing.Point(417,119)
$windowssearch.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$actioncenter                    = New-Object system.Windows.Forms.Button
$actioncenter.text               = "Action Center"
$actioncenter.width              = 150
$actioncenter.height             = 30
$actioncenter.location           = New-Object System.Drawing.Point(251,9)
$actioncenter.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$lightmode                       = New-Object system.Windows.Forms.Button
$lightmode.text                  = "Light Mode"
$lightmode.width                 = 150
$lightmode.height                = 30
$lightmode.location              = New-Object System.Drawing.Point(417,45)
$lightmode.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$darkmode                        = New-Object system.Windows.Forms.Button
$darkmode.text                   = "Dark Mode"
$darkmode.width                  = 150
$darkmode.height                 = 30
$darkmode.location               = New-Object System.Drawing.Point(417,7)
$darkmode.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$visualfx                        = New-Object system.Windows.Forms.Button
$visualfx.text                   = "Visual FX"
$visualfx.width                  = 150
$visualfx.height                 = 30
$visualfx.location               = New-Object System.Drawing.Point(417,82)
$visualfx.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$onedrive                        = New-Object system.Windows.Forms.Button
$onedrive.text                   = "OneDrive"
$onedrive.width                  = 150
$onedrive.height                 = 30
$onedrive.location               = New-Object System.Drawing.Point(251,119)
$onedrive.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$objPanel3                       = New-Object system.Windows.Forms.Panel
$objPanel3.height                = 158
$objPanel3.width                 = 440
$objPanel3.location              = New-Object System.Drawing.Point(601,293)

$objLabel4                       = New-Object system.Windows.Forms.Label
$objLabel4.text                  = "Security"
$objLabel4.AutoSize              = $true
$objLabel4.width                 = 117
$objLabel4.height                = 25
$objLabel4.location              = New-Object System.Drawing.Point(761,252)
$objLabel4.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',24)

$securitylow                     = New-Object system.Windows.Forms.Button
$securitylow.text                = "Low"
$securitylow.width               = 150
$securitylow.height              = 30
$securitylow.location            = New-Object System.Drawing.Point(36,119)
$securitylow.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',15,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$securityhigh                    = New-Object system.Windows.Forms.Button
$securityhigh.text               = "High"
$securityhigh.width              = 150
$securityhigh.height             = 30
$securityhigh.location           = New-Object System.Drawing.Point(244,119)
$securityhigh.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',15,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$objLabel5                       = New-Object system.Windows.Forms.Label
$objLabel5.text                  = ""
$objLabel5.AutoSize              = $true
$objLabel5.width                 = 150
$objLabel5.height                = 10
$objLabel5.location              = New-Object System.Drawing.Point(24,40)
$objLabel5.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$objLabel6                       = New-Object system.Windows.Forms.Label
$objLabel6.text                  = "- Disable Meltdown Flag"
$objLabel6.AutoSize              = $true
$objLabel6.width                 = 150
$objLabel6.height                = 10
$objLabel6.location              = New-Object System.Drawing.Point(24,6)
$objLabel6.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$objLabel7                       = New-Object system.Windows.Forms.Label
$objLabel7.text                  = "- Set UAC to Never Prompt"
$objLabel7.AutoSize              = $true
$objLabel7.width                 = 150
$objLabel7.height                = 10
$objLabel7.location              = New-Object System.Drawing.Point(24,23)
$objLabel7.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$objLabel8                       = New-Object system.Windows.Forms.Label
$objLabel8.text                  = ""
$objLabel8.AutoSize              = $true
$objLabel8.width                 = 150
$objLabel8.height                = 10
$objLabel8.location              = New-Object System.Drawing.Point(24,75)
$objLabel8.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$objLabel9                       = New-Object system.Windows.Forms.Label
$objLabel9.text                  = ""
$objLabel9.AutoSize              = $true
$objLabel9.width                 = 150
$objLabel9.height                = 10
$objLabel9.location              = New-Object System.Drawing.Point(24,58)
$objLabel9.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$objLabel10                      = New-Object system.Windows.Forms.Label
$objLabel10.text                 = "- Set UAC to Always Prompt"
$objLabel10.AutoSize             = $true
$objLabel10.width                = 25
$objLabel10.height               = 10
$objLabel10.location             = New-Object System.Drawing.Point(233,40)
$objLabel10.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$objLabel11                      = New-Object system.Windows.Forms.Label
$objLabel11.text                 = "- Enable Windows Defender"
$objLabel11.AutoSize             = $true
$objLabel11.width                = 25
$objLabel11.height               = 10
$objLabel11.location             = New-Object System.Drawing.Point(233,57)
$objLabel11.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$objLabel12                      = New-Object system.Windows.Forms.Label
$objLabel12.text                 = "- Enable Windows Malware Scan"
$objLabel12.AutoSize             = $true
$objLabel12.width                = 25
$objLabel12.height               = 10
$objLabel12.location             = New-Object System.Drawing.Point(233,6)
$objLabel12.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$objLabel13                      = New-Object system.Windows.Forms.Label
$objLabel13.text                 = "- Enable Meltdown Flag"
$objLabel13.AutoSize             = $true
$objLabel13.width                = 25
$objLabel13.height               = 10
$objLabel13.location             = New-Object System.Drawing.Point(233,23)
$objLabel13.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$objLabel15                      = New-Object system.Windows.Forms.Label
$objLabel15.text                 = "Windows Update"
$objLabel15.AutoSize             = $true
$objLabel15.width                = 25
$objLabel15.height               = 10
$objLabel15.location             = New-Object System.Drawing.Point(58,459)
$objLabel15.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',24)

$objPanel4                       = New-Object system.Windows.Forms.Panel
$objPanel4.height                = 168
$objPanel4.width                 = 340
$objPanel4.location              = New-Object System.Drawing.Point(9,491)

$defaultwindowsupdate            = New-Object system.Windows.Forms.Button
$defaultwindowsupdate.text       = "Default Settings"
$defaultwindowsupdate.width      = 300
$defaultwindowsupdate.height     = 30
$defaultwindowsupdate.location   = New-Object System.Drawing.Point(20,13)
$defaultwindowsupdate.Font       = New-Object System.Drawing.Font('Microsoft Sans Serif',14)

$securitywindowsupdate           = New-Object system.Windows.Forms.Button
$securitywindowsupdate.text      = "Security Updates Only"
$securitywindowsupdate.width     = 300
$securitywindowsupdate.height    = 30
$securitywindowsupdate.location  = New-Object System.Drawing.Point(20,119)
$securitywindowsupdate.Font      = New-Object System.Drawing.Font('Microsoft Sans Serif',14)

$objLabel16                      = New-Object system.Windows.Forms.Label
$objLabel16.text                 = "I recommend doing security updates only."
$objLabel16.AutoSize             = $true
$objLabel16.width                = 25
$objLabel16.height               = 10
$objLabel16.location             = New-Object System.Drawing.Point(47,49)
$objLabel16.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$objLabel17                      = New-Object system.Windows.Forms.Label
$objLabel17.text                 = "- Delays Features updates up to 3 years"
$objLabel17.AutoSize             = $true
$objLabel17.width                = 25
$objLabel17.height               = 10
$objLabel17.location             = New-Object System.Drawing.Point(71,66)
$objLabel17.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$objLabel18                      = New-Object system.Windows.Forms.Label
$objLabel18.text                 = "- Delays Security updates 4 days"
$objLabel18.AutoSize             = $true
$objLabel18.width                = 25
$objLabel18.height               = 10
$objLabel18.location             = New-Object System.Drawing.Point(71,84)
$objLabel18.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$objLabel19                      = New-Object system.Windows.Forms.Label
$objLabel19.text                 = "- Sets Maximum Active Time"
$objLabel19.AutoSize             = $true
$objLabel19.width                = 25
$objLabel19.height               = 10
$objLabel19.location             = New-Object System.Drawing.Point(71,103)
$objLabel19.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$objLabel20                      = New-Object system.Windows.Forms.Label
$objLabel20.text                 = "Instructions"
$objLabel20.AutoSize             = $true
$objLabel20.width                = 169
$objLabel20.height               = 23
$objLabel20.location             = New-Object System.Drawing.Point(581,463)
$objLabel20.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',24)

$objLabel21                      = New-Object system.Windows.Forms.Label
$objLabel21.text                 = "- This will modify your system and I highly recommend backing up any data you have prior to running!"
$objLabel21.AutoSize             = $true
$objLabel21.width                = 150
$objLabel21.height               = 10
$objLabel21.location             = New-Object System.Drawing.Point(390,507)
$objLabel21.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$objLabel22                      = New-Object system.Windows.Forms.Label
$objLabel22.text                 = "(Unsure!?... Just apply Essential Tweaks)"
$objLabel22.AutoSize             = $true
$objLabel22.width                = 150
$objLabel22.height               = 10
$objLabel22.location             = New-Object System.Drawing.Point(4,14)
$objLabel22.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$objLabel23                      = New-Object system.Windows.Forms.Label
$objLabel23.text                 = "- Need to Restore action center, cortana, etc.? Run the Restore Script: https://youtu.be/H2ydDcqRZyM"
$objLabel23.AutoSize             = $true
$objLabel23.width                = 150
$objLabel23.height               = 10
$objLabel23.location             = New-Object System.Drawing.Point(390,529)
$objLabel23.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

# Base64 PictureBox
$base64ImageString               = "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T89FwoQbaVaFhYXLV69ePc7j8eg5Fq+9dOmS5/rrr+9fVlaWKVtG3GPHjt00derUs71793anpKTA7/dLVVVV2LFjh+69997rsGHDhlv8fr+qqqoq65Zbbpn4008/LUhMTHRw7g9qxvULiAxblGk+ny/9gQce6LJgwYI7qRWlX79+2+6+++4Tw4cPr2vVqpXXbDarLBaL/+LFi6qVK1cmLV68uMuBAwcKAGDdunUDunTpcmrfvn1HExMTzRqNxk7aUiF04Wgd50JLA5Bus9nShgwZcvPOnTv7EcuRp3///tvuvPPOU8OGDavLyMjwJSUlSXV1df6Kigpp+/btxqVLl+auX7/+JofDYQaAFStWjOzatWvHbdu2LW/Tpo3IVemmcz169GhL+/bt9505c6ZHKAtW//791yYmJvo4Qs20Omo1DDqNeNddd32zYMGCe91utyKZzsjIOPXggw+eEygO4DXX4uLilF69ej1QXV0dqAWZl5d34J577jncv39/63XXXedJSEjwGQwG1NfX+2tqalSHDx/WbNq0KXnhwoUFZ8+e7eh0Ok0TJ068nxBIPQF23pIb6VpoKWIlOpBj12q1NqblouEgDT0prIJybjSRS4opdDRexcZkXafT0YM3NL6I4aJIxlObIuPl5eXSjh07IpFxcG5dH+eZ4JUtvk/9Y9QnH5SP/0tNIE2xIllNIljyGpFeffXV8ieffHJS4JdGo3XkyJFb77vvvvMFBQXOjIwMv1qtRnl5uVRUVKT94osvWi1fvvymqqqqVgCwb9++G7p165a5cePGpV27dhWdaKQhAipB2EGzMDPCuZO4eC2RUSOwHqdNm3Z03bp15TabLU2J0JhMptrHH398PxoC2R0Iji01Tps2reqLL744U1JS0i6E18l+3333fa8QdxX1j6YFACygzXXo0MFJCFYcgo9pstgGo8/n02/ZsqUAAPr27XtQp9OZx48ff/DDDz8csnv37p4Oh2OfwWBgA81IgRaA9tSpUzpCsOoFsV48yQpKK/HMM88ceuaZZ55EQ9AdPWURB8Dw8MMPx3/88cejSKJAUY4iKcKxanQq4+uvv94O4AyAzJKSEkN2dva9ALB9+/a4Bx544AaLxZICAF27dj24evXqHbm5uSwOJ5AQMSsrS3vnnXfq77zzzqK9e/ceHzFixKiKiors0tLS3ClTpvRYvny5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"
$imageBytes                      = [Convert]::FromBase64String($base64ImageString)
$ms                              = New-Object IO.MemoryStream($imageBytes, 0, $imageBytes.Length)
$ms.Write($imageBytes, 0, $imageBytes.Length);
$tituslogo                       = [System.Drawing.Image]::FromStream($ms, $true)

$PictureBox1                     = New-Object Windows.Forms.PictureBox
$PictureBox1.width               = 412
$PictureBox1.height              = 125
$PictureBox1.Location            = New-Object System.Drawing.Size(449,541)
$PictureBox1.Image               = $tituslogo
$pictureBox1.SizeMode            = [System.Windows.Forms.PictureBoxSizeMode]::Zoom

$objForm.controls.AddRange(@($objPanel1,$objLabel1,$objPanel2,$objLabel3,$objPanel3,$objLabel4,$objLabel15,$objPanel4,$objLabel20,$objLabel21,$objLabel23,$PictureBox1))
$objPanel1.controls.AddRange(@($installchoco,$brave,$firefox,$7zip,$irfanview,$adobereader,$notepad,$gchrome,$mpc,$vlc,$powertoys,$winterminal,$vscode,$objLabel2))
$objPanel2.controls.AddRange(@($essentialtweaks,$backgroundapps,$cortana,$windowssearch,$actioncenter,$darkmode,$visualfx,$onedrive,$objLabel22,$lightmode))
$objPanel3.controls.AddRange(@($securitylow,$securityhigh,$objLabel5,$objLabel6,$objLabel7,$objLabel8,$objLabel9,$objLabel10,$objLabel11,$objLabel12,$objLabel13))
$objPanel4.controls.AddRange(@($defaultwindowsupdate,$securitywindowsupdate,$objLabel16,$objLabel17,$objLabel18,$objLabel19))


$installchoco.Add_Click({ 
    Write-Host "Installing Chocolatey"
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	choco install chocolatey-core.extension -y
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$brave.Add_Click({ 
	Write-Host "Installing Brave Browser"
	choco install brave -y
	    [Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')	
})

$firefox.Add_Click({ 
    Write-Host "Installing Firefox"
    choco install firefox -y
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$gchrome.Add_Click({ 
    Write-Host "Installing Google Chrome"
    choco install googlechrome -y
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$irfanview.Add_Click({ 
    Write-Host "Installing Irfanview (Image Viewer)"
    choco install irfanview -y
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$adobereader.Add_Click({ 
    Write-Host "Installing Adobe Reader DC"
    choco install adobereader -y
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$notepad.Add_Click({ 
    Write-Host "Installing Notepad++"
    choco install notepadplusplus -y
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$vlc.Add_Click({ 
    Write-Host "Installing VLC Media Player"
    choco install vlc -y
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$mpc.Add_Click({ 
    Write-Host "Installing Media Player Classic"
    choco install mpc-be -y
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$7zip.Add_Click({ 
    Write-Host "Installing 7-Zip Compression Tool"
    choco install 7zip -y
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$vscode.Add_Click({ 
    Write-Host "Installing Visual Studio Code"
    choco install vscode -y
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$winterminal.Add_Click({ 
    Write-Host "Installing New Windows Terminal"
    choco install microsoft-windows-terminal -y
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$powertoys.Add_Click({ 
    Write-Host "Installing Microsoft PowerToys"
    choco install powertoys -y
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$essentialtweaks.Add_Click({ 
    Write-Host "Creating Restore Point incase something bad happens"
    Enable-ComputerRestore -Drive "C:\"
    Checkpoint-Computer -Description "RestorePoint1" -RestorePointType "MODIFY_SETTINGS"

	Write-Host "Running O&O Shutup with Recommended Settings"
    Import-Module BitsTransfer		choco install shutup10 -y
	Start-BitsTransfer -Source "https://raw.githubusercontent.com/ChrisTitusTech/win10script/master/ooshutup10.cfg" -Destination ooshutup10.cfg		OOSU10 ooshutup10.cfg /quiet
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



$Bloatware = @(

        #Unnecessary Windows 10 AppX Apps
        "Microsoft.3DBuilder"
        "Microsoft.AppConnector"
	    "Microsoft.BingFinance"
	    "Microsoft.BingNews"
	    "Microsoft.BingSports"
	    "Microsoft.BingTranslator"
	    "Microsoft.BingWeather"
        "Microsoft.GetHelp"
        "Microsoft.Getstarted"
        "Microsoft.Messaging"
        "Microsoft.Microsoft3DViewer"
        "Microsoft.MicrosoftSolitaireCollection"
        "Microsoft.NetworkSpeedTest"
        "Microsoft.News"
        "Microsoft.Office.Lens"
        "Microsoft.Office.Sway"
        "Microsoft.OneConnect"
        "Microsoft.People"
        "Microsoft.Print3D"
        "Microsoft.SkypeApp"
        "Microsoft.StorePurchaseApp"
        "Microsoft.Wallet"
        "Microsoft.Whiteboard"
        "Microsoft.WindowsAlarms"
        "microsoft.windowscommunicationsapps"
        "Microsoft.WindowsFeedbackHub"
        "Microsoft.WindowsMaps"
        "Microsoft.WindowsSoundRecorder"
        "Microsoft.ZuneMusic"
        "Microsoft.ZuneVideo"

        #Sponsored Windows 10 AppX Apps
        #Add sponsored/featured apps to remove in the "*AppName*" format
        "*EclipseManager*"
        "*ActiproSoftwareLLC*"
        "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
        "*Duolingo-LearnLanguagesforFree*"
        "*PandoraMediaInc*"
        "*CandyCrush*"
        "*BubbleWitch3Saga*"
        "*Wunderlist*"
        "*Flipboard*"
        "*Twitter*"
        "*Facebook*"
        "*Royal Revolt*"
        "*Sway*"
        "*Speed Test*"
        "*Dolby*"
        "*Viber*"
        "*ACGMediaPlayer*"
        "*Netflix*"
        "*OneCalendar*"
        "*LinkedInforWindows*"
        "*HiddenCityMysteryofShadows*"
        "*Hulu*"
        "*HiddenCity*"
        "*AdobePhotoshopExpress*"
                     
        #Optional: Typically not removed but you can if you need to for some reason
        #"*Microsoft.Advertising.Xaml_10.1712.5.0_x64__8wekyb3d8bbwe*"
        #"*Microsoft.Advertising.Xaml_10.1712.5.0_x86__8wekyb3d8bbwe*"
        #"*Microsoft.BingWeather*"
        #"*Microsoft.MSPaint*"
        #"*Microsoft.MicrosoftStickyNotes*"
        #"*Microsoft.Windows.Photos*"
        #"*Microsoft.WindowsCalculator*"
        #"*Microsoft.WindowsStore*"
    )
    foreach ($Bloat in $Bloatware) {
        Get-AppxPackage -Name $Bloat| Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online
        Write-Host "Trying to remove $Bloat."
    }

    #Write-Host "Installing Windows Media Player..."
	#Enable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer" -NoRestart -WarningAction SilentlyContinue | Out-Null

    #Stops edge from taking over as the default .PDF viewer    
    Write-Host "Stopping Edge from taking over as the default .PDF viewer"
	# Identify the edge application class 
	$Packages = "HKCU:SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\Repository\Packages" 
	$edge = Get-ChildItem $Packages -Recurse -include "MicrosoftEdge" 
		
	# Specify the paths to the file and URL associations 
	$FileAssocKey = Join-Path $edge.PSPath Capabilities\FileAssociations 
	$URLAssocKey = Join-Path $edge.PSPath Capabilities\URLAssociations 
		
	# get the software classes for the file and URL types that Edge will associate 
	$FileTypes = Get-Item $FileAssocKey 
	$URLTypes = Get-Item $URLAssocKey 
		
	$FileAssoc = Get-ItemProperty $FileAssocKey 
	$URLAssoc = Get-ItemProperty $URLAssocKey 
		
	$Associations = @() 
	$Filetypes.Property | foreach {$Associations += $FileAssoc.$_} 
	$URLTypes.Property | foreach {$Associations += $URLAssoc.$_} 
		
	# add registry values in each software class to stop edge from associating as the default 
	foreach ($Association in $Associations) 
			{ 
			$Class = Join-Path HKCU:SOFTWARE\Classes $Association 
			#if (Test-Path $class) 
			#   {write-host $Association} 
			# Get-Item $Class 
			Set-ItemProperty $Class -Name NoOpenWith -Value "" 
			Set-ItemProperty $Class -Name NoStaticDefaultVerb -Value "" 
			} 
            
    
    #Removes Paint3D stuff from context menu
$Paint3Dstuff = @(
        "HKCR:\SystemFileAssociations\.3mf\Shell\3D Edit"
	"HKCR:\SystemFileAssociations\.bmp\Shell\3D Edit"
	"HKCR:\SystemFileAssociations\.fbx\Shell\3D Edit"
	"HKCR:\SystemFileAssociations\.gif\Shell\3D Edit"
	"HKCR:\SystemFileAssociations\.jfif\Shell\3D Edit"
	"HKCR:\SystemFileAssociations\.jpe\Shell\3D Edit"
	"HKCR:\SystemFileAssociations\.jpeg\Shell\3D Edit"
	"HKCR:\SystemFileAssociations\.jpg\Shell\3D Edit"
	"HKCR:\SystemFileAssociations\.png\Shell\3D Edit"
	"HKCR:\SystemFileAssociations\.tif\Shell\3D Edit"
	"HKCR:\SystemFileAssociations\.tiff\Shell\3D Edit"
    )
    #Rename reg key to remove it, so it's revertible
    foreach ($Paint3D in $Paint3Dstuff) {
        If (Test-Path $Paint3D) {
	    $rmPaint3D = $Paint3D + "_"
	    Set-Item $Paint3D $rmPaint3D
	}
    }
    
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
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
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$backgroundapps.Add_Click({ 
    Write-Host "Disabling Background application access..."
	Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Exclude "Microsoft.Windows.Cortana*" | ForEach {
		Set-ItemProperty -Path $_.PsPath -Name "Disabled" -Type DWord -Value 1
		Set-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -Type DWord -Value 1
	}
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
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
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$securitylow.Add_Click({ 
    Write-Host "Lowering UAC level..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SpynetReporting" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent" -Type DWord -Value 2
    Write-Host "Disabling Meltdown (CVE-2017-5754) compatibility flag..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat" -Name "cadca5fe-87d3-4b96-b7fb-a231484277cc" -ErrorAction SilentlyContinue
    [Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$securityhigh.Add_Click({ 
    Write-Host "Raising UAC level..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 5
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Type DWord -Value 1
    Write-Host "Disabling SMB 1.0 protocol..."
	Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force
    Write-Host "Enabling Windows Defender..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -ErrorAction SilentlyContinue
	If ([System.Environment]::OSVersion.Version.Build -eq 14393) {
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsDefender" -Type ExpandString -Value "`"%ProgramFiles%\Windows Defender\MSASCuiL.exe`""
	} ElseIf ([System.Environment]::OSVersion.Version.Build -ge 15063) {
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "SecurityHealth" -Type ExpandString -Value "`"%ProgramFiles%\Windows Defender\MSASCuiL.exe`""
	}
    Write-Host "Enabling Windows Defender Cloud..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SpynetReporting" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent" -ErrorAction SilentlyContinue
    Write-Host "Disabling Windows Script Host..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name "Enabled" -Type DWord -Value 0
    Write-Host "Enabling Meltdown (CVE-2017-5754) compatibility flag..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat" -Name "cadca5fe-87d3-4b96-b7fb-a231484277cc" -Type DWord -Value 0
    Write-Host "Enabling Malicious Software Removal Tool offering..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name "DontOfferThroughWUAU" -ErrorAction SilentlyContinue
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
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
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
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
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$actioncenter.Add_Click({ 
    Write-Host "Disabling Action Center..."
	If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer")) {
		New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -Type DWord -Value 1
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Type DWord -Value 0
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
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
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
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
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$darkmode.Add_Click({ 
    Write-Host "Enabling Dark Mode"
	Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

$lightmode.Add_Click({ 
    Write-Host "Switching Back to Light Mode"
	Remove-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme
	[Microsoft.VisualBasic.Interaction]::MsgBox('Done','OKOnly,SystemModal,Information', 'Done')
})

# modal
$objForm.Topmost = $True
$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()
