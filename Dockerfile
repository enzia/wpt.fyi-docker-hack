FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:alpine

# Create a non-priviledged user to run browsers as (Firefox and Chrome do not
# like to run as root).
RUN chmod a+rx $HOME && addgroup browser && adduser --uid 9999 --disabled-password --ingroup browser browser

# firefox-esr: provides deps for Firefox (we don't use ESR directly)
# nodejs & npm: not as secure as Node LTS, but we're not shipping this to prod anyway
# openjdk11-jdk: provides JDK/JRE to Selenium & gcloud SDK
# py3-crcmod: native module to speed up CRC checksum in gsutil
RUN apk --update add \
        curl \
        firefox-esr \
        go \
        openjdk11-jdk \
        make \
        nodejs \
        npm \
        python3 \
        py3-crcmod \
        sudo \
        py3-tox \
        wget \
        xvfb && \
    rm /usr/bin/firefox

# The base golang image adds Go paths to PATH, which cannot be inherited in
# sudo by default because of the `secure_path` directive. Overwrite sudoers to
# discard the setting.
RUN echo "root ALL=(ALL:ALL) ALL" > /etc/sudoers

RUN gcloud -q components install app-engine-go && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud --version
