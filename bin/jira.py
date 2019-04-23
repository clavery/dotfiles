#!/Users/clavery/bin/env/bin/python
import requests
import yaml
import webbrowser
import fileinput
import sys

USER = "clavery"
with open("/Users/clavery/.atlassianpw", 'r') as f:
    PASSWORD = f.read().strip()
AUTH = (USER, PASSWORD)
BASE_URL = "https://pixelmedia.atlassian.net/rest/api/latest/"

def create_issue_from_dict(data):
    issuetype = "Task"
    if 'issuetype' in data:
        issuetype = data['issuetype']

    j = {
        "fields": {
            "project": {
                "key": data.get('project')
            },
            "summary": data.get('summary'),
            "description": data.get('description'),
            "issuetype": {
                "name": issuetype
            },
            "security" : {"name" : "PixelMEDIA + Contractors"}
        }
    }

    if "components" in data and data["components"]:
        j["fields"]["components"] = [{"name":c} for c in data.get('components').split(',')]

    if "estimate" in data and data["estimate"]:
        j['fields']["timetracking"] = {
            "originalEstimate": data["estimate"],
            "remainingEstimate": data["estimate"]
        }

    if "parent" in data and data["parent"]:
        j['fields']['parent'] = {"key" : data["parent"]}


    resp = requests.post("{}issue".format(BASE_URL), json=j, auth=AUTH)
    resp.raise_for_status()

    key = resp.json().get("key")

    if "subtasks" in data and data["subtasks"]:
        for subtask in data["subtasks"]:
            js = {
                "fields": {
                    "project": {
                        "key": data.get('project')
                    },
                    "parent":
                    {
                        "key": key
                    },
                    "summary": subtask.get('summary'),
                    "description": subtask.get('description'),
                    "issuetype": {
                        "name": 'Sub-task'
                    },
                    "security" : {"name" : "PixelMEDIA + Contractors"}
                }
            }
            if "estimate" in subtask and subtask["estimate"]:
                js['fields']["timetracking"] = {
                    "originalEstimate": subtask["estimate"],
                    "remainingEstimate": subtask["estimate"]
                }
            if "components" in subtask and subtask["components"]:
                js["fields"]["components"] = [{"name":c} for c in subtask.get('components').split(',')]
            elif "components" in j["fields"]:
                js["fields"]["components"] = j["fields"]["components"]

            resp = requests.post("{}issue".format(BASE_URL), json=js, auth=AUTH)
            resp.raise_for_status()
    return key


yamldata = "\n".join([line for line in fileinput.input(sys.argv[1:])])

issues = []
for issue in yaml.load(yamldata):
    try:
        issue_id = create_issue_from_dict(issue)
    except requests.HTTPError as e:
        print(e.response.status_code)
        print(e.response.json())
        sys.exit(1)
    issues.append(issue_id)

webbrowser.open("https://pixelmedia.atlassian.net/issues/?jql=resolution = Unresolved and key in ({0}) or parent in ({0}) ORDER BY issue,priority".format(",".join(issues)))
