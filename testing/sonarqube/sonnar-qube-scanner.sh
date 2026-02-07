docker run --rm --network web-app-network \
    -e SONAR_HOST_URL="http://bca-sonarqube:9000" \
    -e SONAR_SCANNER_OPTS="\
    -Dsonar.projectKey=django-todolist \
    -Dsonar.sources=. \
    -Dsonar.python.version=3.12 \
    -Dsonar.scm.provider=git \
    -Dsonar.scm.disabled=false" \
    -e SONAR_TOKEN="[SEU TOKEN AQUI]" \
    -v "/Users/ederlino.tavares/dev/projects/bca/django_todolist:/usr/src" \
    -v "/Users/ederlino.tavares/dev/projects/bca/django_todolist/.git:/usr/src/.git" \
    --platform='linux/amd64' \
    sonarsource/sonar-scanner-cli
