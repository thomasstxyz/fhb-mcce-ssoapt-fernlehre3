# SSOA-PT Schütz // Fernlehre 3 - Secure Cloud Application

Das Ziel dieser Übung ist die unter https://fhb-codelabs.github.io/codelabs/virt-pt-terraform-ec2-cloudinit/index.html bereitgestellte Microservice Applikation entsprechend der erworbenen Fähigkeiten abzusichern.

- Verbesserung der Ausfallsicherheit
- Transportverschlüsselung
- Secrets
- Authentifizierung
- Supply Chain
- Observability

## Installation

    terraform init
    terraform apply

After applying, you see the outputs `application_name`, `homepage_url` and `auth_callback_url`.
Use these values in the next step.

- Create a new OAuth App in your GitHub profile at https://github.com/settings/developers
- Note the client ID
- Generate a new client secret and note it

SSH to podtatohead-main.

Once on the shell, save the secrets into environment variables (fill in the values).

    export GITHUB_USER=your_github_username
    export GITHUB_CLIENT_ID=your_client_id
    export GITHUB_CLIENT_SECRET=your_client_secret

Start oauth-proxy.

    export COOKIE_SECRET=$(python -c 'import os,base64; print(base64.urlsafe_b64encode(os.urandom(16)).decode())')
    export PUBLIC_URL=$(curl http://169.254.169.254/latest/meta-data/public-ipv4).nip.io
    sudo /opt/oauth2-proxy/oauth2-proxy --github-user="${GITHUB_USER}"  --cookie-secret="${COOKIE_SECRET}" --client-id="${GITHUB_CLIENT_ID}" --client-secret="${GITHUB_CLIENT_SECRET}" --email-domain="*" --upstream=http://127.0.0.1:8080 --provider github --cookie-secure false --redirect-url=https://${PUBLIC_URL}/oauth2/callback --https-address=":443" --force-https --tls-cert-file=/etc/letsencrypt/live/$PUBLIC_URL/fullchain.pem --tls-key-file=/etc/letsencrypt/live/$PUBLIC_URL/privkey.pem

Now browse to your `homepage_url` and try to log in!

## Vorgenommene Maßnahmen

- [623685f](https://github.com/thomas2110781014/fhb-mcce-ssoapt-fernlehre3/commit/623685fc43b55ebc7614f4ab155dc2741158268a) Docker Container unter einem unprivilegierten Benutzer laufen lassen.
- [380f41a](https://github.com/thomas2110781014/fhb-mcce-ssoapt-fernlehre3/commit/380f41a73e72ecb316c1f9db19e47dddbe413179) OAuth Authentication und HTTPS.
- [3d97a3e](https://github.com/thomas2110781014/fhb-mcce-ssoapt-fernlehre3/commit/3d97a3e58d90547acc13c4a2fff6f60247f06709) Überprüfung der Prüfsummen von Container Images.
