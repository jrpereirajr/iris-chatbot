ARG IMAGE=intersystemsdc/iris-community
FROM $IMAGE

ARG MODULE=iris-chatbot

USER root

RUN apt update && apt install -y inotify-tools nano
        
WORKDIR /opt/irisbuild
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild

USER ${ISC_PACKAGE_MGRUSER}

COPY src src
COPY module.xml module.xml
COPY iris.script iris.script
COPY requirements.txt requirements.txt
COPY python-watch.sh python-watch.sh

USER root

RUN chmod +x /opt/irisbuild/python-watch.sh
RUN chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild

USER ${ISC_PACKAGE_MGRUSER}

ARG TESTS=1

# breaks the chatterbot installation
# ENV PIP_TARGET=${ISC_PACKAGE_INSTALLDIR}/mgr/python

RUN /usr/irissys/bin/irispython -m pip install --upgrade pip && \
    /usr/irissys/bin/irispython -m pip install -r requirements.txt && \
    /usr/irissys/bin/irispython -m pip install chatterbot_corpus && \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    iris session iris "##class(%ZPM.PackageManager).Shell(\"load /opt/irisbuild -v\",1,1)" && \
    ([ $TESTS -eq 0 ] || iris session iris "##class(%ZPM.PackageManager).Shell(\"test $MODULE -v -only\",1,1)") && \
    iris stop IRIS quietly
