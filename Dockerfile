FROM httpd:latest

# Enable required modules
RUN sed -i '/LoadModule autoindex_module/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/LoadModule alias_module/s/^#//g' /usr/local/apache2/conf/httpd.conf

# Configure icon alias to point to Apache's built-in icons
RUN echo "\n\
Alias /icons/ /usr/local/apache2/icons/\n\
<Directory \"/usr/local/apache2/icons\">\n\
    Options Indexes MultiViews\n\
    AllowOverride None\n\
    Require all granted\n\
</Directory>\n\
" >> /usr/local/apache2/conf/httpd.conf

# Configure FancyIndexing with proper icon paths
RUN echo "\n\
<Directory \"/usr/local/apache2/htdocs\">\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride None\n\
    Require all granted\n\
    IndexOptions FancyIndexing VersionSort NameWidth=* HTMLTable\n\
    IndexOptions ScanHTMLTitles SuppressDescription IconsAreLinks FoldersFirst\n\
    IndexIgnore .??* *~ *# HEADER* RCS CVS *,v *,t\n\
    ReadmeName README.html\n\
    HeaderName HEADER.html\n\
    # Icon definitions\n\
    AddIcon /icons/blank.gif ^^BLANKICON^^\n\
    AddIcon /icons/folder.gif ^^DIRECTORY^^\n\
    AddIcon /icons/back.gif ..\n\
    AddIconByType (TXT,/icons/text.gif) text/*\n\
    AddIconByType (IMG,/icons/image2.gif) image/*\n\
    AddIconByType (SND,/icons/sound2.gif) audio/*\n\
    AddIconByType (VID,/icons/movie.gif) video/*\n\
    AddIcon /icons/binary.gif .bin .exe\n\
    AddIcon /icons/compressed.gif .zip .gz .tgz\n\
    AddIcon /icons/script.gif .sh .py .js\n\
    DefaultIcon /icons/unknown.gif\n\
    AddDescription \"README file\" README* readme*\n\
</Directory>\n\
" >> /usr/local/apache2/conf/httpd.conf
