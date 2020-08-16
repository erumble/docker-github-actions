docker run \
	-d \
	-e RUNNER_NAME=gha-vagrant \
	-e RUNNER_REPOSITORY_URL=$GHA_REPO_URL \
	-e GITHUB_ACCESS_TOKEN=$GHA_ACCESS_TOKEN \
	-e RUNNER_LABELS=gha-vagrant,vagrant \
	-v /var/run/docker.sock:/var/run/docker.sock \
	gha
