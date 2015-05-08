# About

This Repository / Docker-Image makes it easy to start hosting a [Atlassian
Confluence](https://www.atlassian.com/software/confluence) - Instance. It is
located at the following places:

* Docker-Image: [https://registry.hub.docker.com/u/derjudge/confluence](https://registry.hub.docker.com/u/derjudge/confluence)
* Git-Repository: [https://bitbucket.org/Judge82/docker_confluence.git](https://bitbucket.org/Judge82/docker_confluence.git)

I started this project as a fork of [cptactionhank/atlassian-confluence](https://registry.hub.docker.com/u/cptactionhank/atlassian-confluence),
because I wanted to change two things in it:

1. cptactionhank's version does not contain a DB like PostgreSQL or MariaDB/MySQL.
This is not a lack! Actually, it is good style and commendable, since Docker's
concept is to link a DB-Container if you need one. But I wanted it as an
as-simple-as-possible way to get started with Confluence, without having to care
 about setting up and linking another DB-Container.
2. The oldest version of Confluence available in cptactionhank's image is 5.5.
The reason I started this image is that I had to migrate an existing Instance of 
Confluence which was powered by version 3.5.13 of the software to the recent
version (which is 5.7.4, at the time of this writing). That's why all the
ancient tags/branches are contained in this container.

There are multiple branches named like the corresponding version of [Atlassian
Confluence](https://www.atlassian.com/software/confluence) it contains. Please
see [Docker image's tags](https://registry.hub.docker.com/u/derjudge/confluence/tags/manage/)
 to get a list of all versions supported so far.

# Getting started

Since this image is for the impatient fellows out there, let's start with the
fastest and easiest way to bring up the most recent version of [Atlassian
Confluence](https://www.atlassian.com/software/confluence) to life. Just type
the following on any Docker-Host:

    docker run -p 8080:8090 -d derjudge/confluence

**Notice**: This is true for all versions, instead of `3.5.*`. Use the following
for these instead (replace `3.5.17` with the version you want to start):

    docker run -p 8080:8080 -d derjudge/confluence:3.5.17

Both variants will take some time to load. You might notice an increased use on
system resources; especially CPU usage will temporary grow up to 100% on one or
more cores. The process generating that load is `java`. This is normal and
perfectly OK, because this means Confluence is starting up and initializing
itself. Based upon the performance of your Docker host, this might take several
minutes to complete; on moderate hardware, usually not longer than 5 minutes.
If it takes noticeable longer, you might want to consider using newer hardware
to host Confluence.

You can determine that everything has started by the following:

* CPU usage lowers significant
* the line `INFO: Server startup in X ms` appears in `/usr/local/atlassian/confluence/logs/catalina.*.log` (inside the
container; use [`docker-enter/nsenter`](https://github.com/jpetazzo/nsenter) to enter the container).
* A ... "positive" line appears in `/usr/local/atlassian/confluence-data/logs/atlassian-confluence.log`. This will be
 something like `init Plugin system started` or `TODO`. What you see there exactly heavily depends on the Confluence
 version you are starting. Again, I'm speaking about the file inside the container; use
 [`docker-enter/nsenter`](https://github.com/jpetazzo/nsenter) to enter the container.
 
Once everything has started, you should be able to point your browser to
`http://<ip-of-your-docker-host>:8080` and see Confluence's landing page.

From this on, just follow [Atlassian's official setup guide](https://confluence.atlassian.com/display/DOC/Confluence+Setup+Guide#ConfluenceSetupGuide-InstallationType2.ChooseyourInstallationType).

# Using included PostgreSQL database

You can either use the internal file-based database to have Confluence initiate it's data structure or use any other
Database System, the container can connect to. This can either be a PostgreSQL or MySQL/MariaDB database you are hosting
in your network or you can use the PostgreSQL database included in this image.

I (and Atlassian) **strongly** recommend to use the included PostgreSQL database or any external database, since the embedded
database is neither very reliable, nor scalable. Also, performance might be quite bad, compared to a mature (and tuned)
DBMS. The PostgreSQL database which is included in this image is not optimized for speed, but for reliability and
 compatibility with a low amount of available resources to support as much hosts as possible, even when they consist of
 older hardware or are quite limited in available resources. If performance is of major importance for you, please
 consider to use an optimized external DBMS instead.

The "Docker way" to do something like this would be to start another container running the DBMS and link the Confluence-
 and DBMS-Container. So it is considered "bad style" to have a DBMS included in this container from a Docker perspective.
But since this image aims to get you started as fast and easy as possible, a PostgreSQL server was included on purpose,
 to not bother you with this additional step.
 
You can freely decide not to make use of it and go the "Docker way". I consider you are experienced enough with Docker
to figure out how this is done, if this is what you want. So it won't be described here. You will find tons of How-Tos
on the Internet.

However, if you decide to use the internal PostgreSQL database, choose and enter the following options and values in the
corresponding dialogues of the Confluence setup steps:

1. `Choose a Database Configuration`: Choose `External Database (PostgreSQL)`
2. `Configure Database`: Choose `Direct JDBC Connection`
3. `Setup Evaluation Database`: Enter `postgres` into `User Name:`-Field. Leave all other fields "as is" (empty password).

# Importing a backup of a former Confluence instance

If you have a backup of another Confluence instance, this easily grows up to several gigabytes in size; you have to count
all images, attachments and so on which grew into your Confluence datastore. Since this is usually too big to upload via
browser. Thus, the best way is to have Docker mount a folder of your Docker host filesystem, which contains this
backup-file, to the path `/usr/local/atlassian/confluence-data/restore` of your Confluence container. This way, you do
not have to upload the file, but simply choose it from a list of available backups during Confluence setup steps.

To do so, simply attach the option `-v /path/to/backup/file/on/your/host:/usr/local/atlassian/confluence-data/restore:ro`
to the `docker run` - command. The following is an example of a complete Docker run - command:

    docker run -p 8080:8080 -v /home/mr/conf-bak:/usr/local/atlassian/confluence-data/restore:ro -d derjudge/confluence:3.5.17

That's all!
