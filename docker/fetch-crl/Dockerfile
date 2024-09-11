# Using almalinux base image
FROM almalinux:9.4

LABEL version="0.6"
LABEL description="Container to update CRLs and certificates"

# Installing EPEL and OSG repositories
RUN sed -i '1,/enabled=0/ s/enabled=0/enabled=1/' /etc/yum.repos.d/almalinux-crb.repo 
RUN dnf install -y https://repo.opensciencegrid.org/osg/3.6/osg-3.6-el9-release-latest.rpm
RUN dnf install -y epel-release
RUN dnf update -y

# Installing the packages that we need
RUN dnf install -y vim 
RUN dnf install -y less 
RUN dnf install -y rsync 
RUN dnf install -y fetch-crl 
RUN dnf install -y osg-ca-scripts
RUN dnf clean all

# Managing directory permissions
RUN chmod -R g+w /etc/osg; \
    chmod -R g+w /var/lib/osg-ca-certs; \
    chmod -R g+w  /etc/grid-security

# Add CA certificates manager entrypoint script
ADD ca-manager.sh /usr/local/bin/

# Run the entryscript
ENTRYPOINT ["bash", "/usr/local/bin/ca-manager.sh"]
