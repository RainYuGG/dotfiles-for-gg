# Use the latest Alpine Linux
FROM alpine:latest

# Install compatibility layer for glibc and FUSE required for AppImage
RUN apk add --no-cache \
    libc6-compat \
    fuse \
    libstdc++

# Copy files from the current build context
COPY Snipaste-2.11.3-x86_64.AppImage /usr/local/bin/snipaste
COPY delta /usr/local/bin/delta
COPY zoxide /usr/local/bin/zoxide
COPY gitstatusd /usr/local/bin/gitstatusd

# Make them executable
RUN chmod +x /usr/local/bin/snipaste /usr/local/bin/delta /usr/local/bin/zoxide /usr/local/bin/gitstatusd
