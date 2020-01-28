FROM centos/systemd:latest

LABEL version="0.1"
LABEL description="Container to update CRLs and certificates"

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://repo.opensciencegrid.org/osg/3.4/osg-3.4-el7-release-latest.rpm
RUN yum -y install yum-plugin-priorities

RUN yum -y install osg-ca-scripts fetch-crl

RUN chmod -R g+w /etc/osg /var/lib/osg-ca-certs /etc/grid-security

ENTRYPOINT osg-ca-manage setupca --location root --url osg --verbose ; fetch-crl --verbose
