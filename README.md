
# docker-limesurvey

This is a basic image of Limesurvey build on top of php:7-apache official image. I've added prerequisite libraries (gd,zip,ldap,imap) and PDO for mysql and postgresql.

No database included, this image aim to be used with an external database

You can export config and upload dirs to docker volumes, it'll be useful to update your installation with a newest image.

The image have an automated build on Docker hub that you can use: https://hub.docker.com/r/jrisp/docker-limesurvey/


For the future, it'll be good to reduce image size.
