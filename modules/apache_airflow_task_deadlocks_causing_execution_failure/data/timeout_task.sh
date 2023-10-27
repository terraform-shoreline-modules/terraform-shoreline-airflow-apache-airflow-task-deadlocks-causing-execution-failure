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