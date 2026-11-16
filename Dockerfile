# Kener status page for Railway.
# Official image, pinned by version and digest. Bump both together (see CHANGELOG.md).
FROM rajnandan1/kener:4.2.1@sha256:116af4895e8054e6855eb9cee49bf1c09528d0204881639790515250e743636c

# Small wrapper: derives ORIGIN from Railway's public domain and makes the
# Redis client work over Railway's private network, then runs the image's own entrypoint.
COPY --chown=node:node railway-start.sh /app/railway-start.sh

ENV PORT=3000

ENTRYPOINT ["sh", "/app/railway-start.sh"]
CMD ["node", "build/main.js"]
