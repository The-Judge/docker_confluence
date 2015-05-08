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

    docker run -p 8080:8080 -d derjudge/confluence

**Notice**: This is true for all versions, instead of '3.5.*'. Use the following
for these instead (replace '3.5.17' with the version you want to start):

    docker run -p 8080:8090 -d derjudge/confluence:3.5.17

Both variants will take some time to load. You might notice an increased use on
system resources; especially CPU usage will temporary grow up to 100% on one or
more cores. The process generating that load is 'java'. This is *normal* and
perfectly OK, because this means Confluence is starting up and initializing
itself based upon the vitality of your Docker host, this might take several
minutes to complete; on moderate hardware, normally not longer than 5 minutes.
If it takes noticeable longer, you might want to consider using newer hardware
to host Confluence.

You can determine that everything has started by CPU usage lowers significant
 and the line 'INFO: Server startup in X ms' appears in '/usr/local/atlassian/confluence/logs/catalina.*.log'.
Once everything has started, you should be able to point your browser to
'http://<ip-of-your-docker-host>:8080' and see Confluence's landing page.

From this on, just follow [Atlassian's official setup guide](https://confluence.atlassian.com/display/DOC/Confluence+Setup+Guide#ConfluenceSetupGuide-InstallationType2.ChooseyourInstallationType).

# Importing a backup of a former Confluence instance

TODO
