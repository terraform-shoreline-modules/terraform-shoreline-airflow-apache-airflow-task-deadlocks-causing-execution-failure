
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Apache Airflow Task Deadlocks Causing Execution Failure
---

This incident type involves the Apache Airflow task deadlocking frequently, leading to the failure of task execution. Deadlocking occurs when two or more tasks are waiting for each other to finish before they can proceed. When this happens, the tasks become stuck, and the workflow stops. This can cause significant downtime and impact on the overall performance of the system. It is crucial to identify the root cause of the deadlocking and resolve it promptly to prevent further incidents.

### Parameters
```shell
export NAMESPACE="PLACEHOLDER"

export AIRFLOW_WORKER_POD_NAME="PLACEHOLDER"

export TASK_NAME="PLACEHOLDER"

export NODE_NAME="PLACEHOLDER"

```

## Debug

### Check if the task is in a deadlock state
```shell
kubectl exec -it -n ${NAMESPACE} ${AIRFLOW_WORKER_POD_NAME} ps aux | grep ${TASK_NAME}
```

### Check if the task is stuck waiting for another task to finish
```shell
kubectl exec -it -n ${NAMESPACE} ${AIRFLOW_WORKER_POD_NAME} ps aux | grep ${TASK_NAME} | grep "waiting on"
```

### Check if the resource limits for the Airflow worker pod are set correctly
```shell
kubectl describe pod -n ${NAMESPACE} ${AIRFLOW_WORKER_POD_NAME} | grep "Limits"
```

### Check if there are any resource constraints on the node where the Airflow worker pod is running
```shell
kubectl describe node ${NODE_NAME} | grep "Capacity" -A 5
```

## Repair

### Modify the task code to handle the deadlocking situation. This may involve adding a timeout function or implementing a retry mechanism.
```shell
bash

#!/bin/bash



# Set variables

TASK_NAME=${TASK_NAME}

COMMAND=${COMMAND}

TIMEOUT=${TIMEOUT_VALUE}


# Update task code to include timeout function

kubectl edit tasks $TASK_NAME --namespace=${NAMESPACE} --output yaml | \

sed 's/command:/command: ["/bin/sh", "-c", "timeout '$TIMEOUT' ${COMMAND}"]/g' | \

kubectl apply --namespace=${NAMESPACE} -f -


```