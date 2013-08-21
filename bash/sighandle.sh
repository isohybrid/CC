#!/bin/bash
function handle()
{
  echo trap, received signal : SIGINT  
}
echo My process ID is $$
trap 'handle' SIGINT

while true;
do
  sleep 1
done
