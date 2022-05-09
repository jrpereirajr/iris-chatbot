 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-chatbot&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-chatbot)


## iris-chatbot

## Online demo

## Installation prerequisites

If you'd like to test the project in your environment, make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## ZPM installation

```
USER>zpm "install iris-chatbot"
```

## Docker installation

If the online demo is not available anymore or you would like to play with the project code, you can set up a docker container. In order to get your container running, follow these steps:

Clone/git pull the repo into any local directory

```
$ git clone git@github.com:jrpereirajr/iris-chatbot.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```

## Unit tests

In order to execute the unit tests, run the following command in the shell terminal:

```bash
iris session iris "##class(%ZPM.PackageManager).Shell(\"test iris-chatbot -v\",1,1)"
```

## Setting up a Telegram bot

In order to use a Telegram bot, follow these steps:

- Create a Telegram bot
  - Access the BotFather in using your Telegram account (https://telegram.me/BotFather)
  - Enter the command `/newbot`
  - Choose a name to your bot
  - Choose a user name to your bot
  - After those information, the BotFather will give you a token for your bot
- Create a IRIS Interoperability credential to store yout bot's token
    - Access the [Credentials Viewer](http://localhost:55038/csp/user/EnsPortal.Credentials.zen?$NAMESPACE=USER&$NAMESPACE=USER&) page
    - Choose a name for the credential in the field `ID`
    - Enter your bot's token in the `Password` field
    - Save your credential
- Setup the production
    - Access the [Production Configuration](http://localhost:55038/csp/user/EnsPortal.ProductionConfig.zen?PRODUCTION=dc.chatbot.TelegramChatbotProduction) page
    - Select the `FromTelegram` business service
    - Find the field `Credentials` in the right panel, in the `Settings` tab, and choose the credentials for your telegram bot
    - Save the changes by clicking in the `Apply` button

Now you can start the production. Access your Telegram bot and start to chat. If everything is OK, you will receive a response from the production's chatbot after a few seconds.