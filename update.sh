DEPLOYMENT_NAME='usecase-classic-pipeline'
BUILD_ID=$2
DEPLOYMENT_FILE='deployment'

echo "Updating image tag in ${DEPLOYMENT_FILE}.yaml..."
sed -i 's|image: .*|image: bhargavqwertyuiop/${DEPLOYMENT_NAME}:${BUILD_ID}|' ${DEPLOYMENT_FILE}.yaml

echo "Configuring Git user..."
git config --global user.name '$(GIT_USER)'
git config --global user.email '$(GIT_EMAIL)'

echo "Pulling latest changes..."
git pull $(REPO_URL) HEAD:main

echo "Adding updated files..."
git add .

echo "Committing changes..."
git commit -m "Update image tag to ${BUILD_ID}"

echo "Pushing changes..."
git push $(REPO_URL) HEAD:main
