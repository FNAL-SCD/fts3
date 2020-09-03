FROM centos/systemd:latest

LABEL version="0.3"
LABEL description="Container to update CRLs and certificates"

# Installing EPEL and OSG repositories and setting EPEL priority to 99
# OSG is at 98 by default
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm ;\
    rpm -Uvh https://repo.opensciencegrid.org/osg/3.5/osg-3.5-el7-release-latest.rpm ;\
    /bin/sed -i '/^enabled=1/a priority=99' /etc/yum.repos.d/epel.repo

# Installing the packages that we need
RUN yum -y install osg-ca-scripts fetch-crl;\
    yum clean all

# Managing directory permissions
RUN chmod -R g+w /etc/osg /var/lib/osg-ca-certs /etc/grid-security

# Add CA certificates manager entrypoint script
ADD ca-manager.sh /usr/local/bin/

# Run the entryscript
ENTRYPOINT ["bash", "/usr/local/bin/ca-manager.sh"]