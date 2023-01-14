# -------------------------------------------------------------------
# Minimal dockerfile from alpine base
#
# Instructions:
# =============
# 1. Create an empty directory and copy the sqlite db file && this file into it.
#
# 2. Create image with: 
#	docker build --tag vt:latest .
#
# 3. Run with: 
# On windows: 
#   docker run -d -p 3000:3000 -v %cd%:/var --name vt.container vt
# On linux: 
#	docker run -d -p 3000:3000 -v $(pwd):/var --name vt.container vt
#
# --------------------------------------------------------------------

FROM node:14-alpine

EXPOSE 3000

LABEL org.label-schema.schema-version="1.3.0"
LABEL org.label-schema.docker.cmd="docker run -d -p 3000:3000 --name VT.container"

RUN apk update
RUN apk upgrade
#Install dependencies
RUN apk add \
    git \
    make \
    python3 \
    g++ \
    gcc \
    libc-dev \
    clang

#Update npm
RUN npm install -g npm

#Add user so it doesn't run as root
RUN adduser --system app --home /app
USER app
WORKDIR /app

#clone app
RUN git clone https://github.com/taknight-101/VT.git 
# WORKDIR /app/timeoff-management/config

#update app.json with correct office365 mail and url variables.
# RUN sed -i 's/"send_emails"              \: false,/"send_emails"              : true,/' app.json
# RUN sed -i 's/email@test.com/noreply@domain.co.uk/' app.json
# RUN sed -i 's/"localhost"/"smtp.office365.com"/' app.json
# RUN sed -i 's/25/587/' app.json
# RUN sed -i '/587,/a|     "secureConnection" : false,' app.json
# RUN sed -i 's/|//' app.json
# RUN sed -i '/"secureConnection" : false,/a|     "tls" : {' app.json
# RUN sed -i 's/|//' app.json
# RUN sed -i '/"tls" : {/a|       "ciphers" : "SSLv3"' app.json
# RUN sed -i 's/|//' app.json
# RUN sed -i '/"ciphers" : "SSLv3"/a|     },' app.json
# RUN sed -i 's/|//' app.json
# RUN sed -i 's/\: "user/\: "noreply@domain.co.uk/' app.json
# RUN sed -i 's/\: "pass/\: "PASSWORD/' app.json
# RUN sed -i 's/http:\/\/app.timeoff.management/https:\/\/holiday.domain.co.uk/' app.json

WORKDIR /app/VT

#bump formidable up a version to fix user import error.
RUN sed -i 's/formidable"\: "~1.0.17/formidable"\: "1.1.1/' package.json

#install app
RUN npm install -y

CMD npm start
