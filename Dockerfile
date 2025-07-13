FROM soerentsch/serviio:latest

# Add a mount point per media type
RUN mkdir -p /media/audio /media/video /media/image