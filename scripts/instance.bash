#!/bin/bash -eu

cmd="$1"

if [ "${STOP_INSTANCE_CONTROL:-}" = "yes" ]
then
  echo "skipped: resource-name=$RESOURCE_NAME, command=$cmd"
  exit 0
fi

case "$cmd" in
  "start")
    instance_state="stopped"
    instance_operation="start-instances"
    ;;
  "stop")
    instance_state="running"
    instance_operation="stop-instances"
    ;;
  * )
    echo "invalid command: $cmd"
    exit 1
    ;;
esac

instance_id="$(
  aws ec2 describe-instances --filters "Name=tag:Name,Values=$RESOURCE_NAME" |
  jq -r ".Reservations[].Instances[] | [.InstanceId, .State.Name] | select(.[1]==\"$instance_state\")[0]" |
  head -1
)"

if [ -n "$instance_id" ]
then
  aws ec2 $instance_operation --instance-ids "$instance_id" > /dev/null
  echo "succeed: resource-name=$RESOURCE_NAME, command=$cmd"

else
  echo "unfound: resource-name=$RESOURCE_NAME, state=$instance_state"
  exit 1

fi
