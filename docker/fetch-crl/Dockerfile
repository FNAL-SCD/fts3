# Using scientific Linux as base
FROM centos:7

LABEL version="0.6"
LABEL description="Container to update CRLs and certificates"

# Installing EPEL and OSG repositories and setting EPEL priority to 99
# OSG is at 98 by default
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm ;\
    rpm -Uvh https://repo.opensciencegrid.org/osg/3.6/osg-3.6-el7-release-latest.rpm;\
    /bin/sed -i '/^enabled=1/a priority=99' /etc/yum.repos.d/epel.repo

# Installing the packages that we need
RUN yum install -y vim less rsync fetch-crl osg-ca-scripts; \
    yum clean all

# Managing directory permissions
RUN chmod -R g+w /etc/osg; \
    chmod -R g+w /var/lib/osg-ca-certs; \
    chmod -R g+w  /etc/grid-security

# Add CA certificates manager entrypoint script
ADD ca-manager.sh /usr/local/bin/

# Run the entryscript
ENTRYPOINT ["bash", "/usr/local/bin/ca-manager.sh"]
