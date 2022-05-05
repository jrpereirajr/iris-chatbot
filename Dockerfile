ARG IMAGE=intersystemsdc/iris-community
FROM $IMAGE

ARG MODULE=iris-chatbot

WORKDIR /home/irisowner/irisbuild
ARG TESTS=0

COPY requirements.txt requirements.txt

RUN --mount=type=bind,src=.,dst=. \
    /usr/irissys/bin/irispython -m pip install --upgrade pip && \
    /usr/irissys/bin/irispython -m pip install -r requirements.txt && \
    /usr/irissys/bin/irispython -m pip install chatterbot_corpus && \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    ([ $TESTS -eq 0 ] || iris session iris "##class(%ZPM.PackageManager).Shell(\"test $MODULE -v -only\",1,1)") && \
    iris stop IRIS quietly
