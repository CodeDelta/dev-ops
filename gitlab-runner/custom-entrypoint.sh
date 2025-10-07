#!/bin/bash

CONFIG_FILE="/etc/gitlab-runner/config.toml"
MAX_ATTEMPTS=120
SLEEP_INTERVAL=10

SEARCH_PATTERN='volumes = \["/cache"\]'
REPLACE_PATTERN='volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]'

/entrypoint run --user=gitlab-runner --working-directory=/home/gitlab-runner &
RUNNER_PID=$!

echo "GitLab Runner started (PID: $RUNNER_PID)."
echo "Waiting for configuration file initialization..."

attempt=0
while [ $attempt -lt $MAX_ATTEMPTS ]; do
  if [ -f "$CONFIG_FILE" ] && grep -q '\[\[runners\]\]' "$CONFIG_FILE"; then
    echo "Configuration file has been initialized."

    changes_made=0

    cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"

    if grep -q "$SEARCH_PATTERN" "$CONFIG_FILE"; then
      echo "Updating 'volumes' configuration..."
      sed -i "s|$SEARCH_PATTERN|$REPLACE_PATTERN|g" "$CONFIG_FILE"
      changes_made=1
    else
      echo "'volumes' configuration already correct or not in initial state."
    fi

    if [ "$ENABLE_GPU" = "true" ]; then
      echo "GPU support is enabled. Checking GPU configurations..."
      if ! grep -q 'gpus = "all"' "$CONFIG_FILE"; then
          echo "Adding 'gpus' configuration..."
          sed -i '/volumes = .*/a \ \ \ \ gpus = "all"' "$CONFIG_FILE"
          changes_made=1
      else
          echo "'gpus' configuration already exists."
      fi
    else
      echo "GPU support is disabled. Removing GPU configurations if they exist..."
      if grep -q 'gpus = "all"' "$CONFIG_FILE"; then
          echo "Removing 'gpus' configuration..."
          sed -i '/[[:space:]]*gpus[[:space:]]*=[[:space:]]*"all"/d' "$CONFIG_FILE"
          changes_made=1
      fi
    fi

    if [ "$changes_made" -eq 1 ]; then
      echo "Configuration successfully updated."
      kill $RUNNER_PID
      echo "Restarting Runner process with new configuration..."
      exec /entrypoint run --user=gitlab-runner \
          --working-directory=/home/gitlab-runner
      exit 0
    else
      echo "No configuration changes were needed."
      rm "${CONFIG_FILE}.bak"
      wait $RUNNER_PID
      exit $?
    fi
  fi

  echo "Configuration file not yet initialized. Waiting ${SLEEP_INTERVAL}"
  echo "seconds... (${attempt}/${MAX_ATTEMPTS})"
  sleep $SLEEP_INTERVAL
  attempt=$((attempt + 1))
done

echo "Timeout: Configuration file was not initialized."
wait $RUNNER_PID
exit $?
