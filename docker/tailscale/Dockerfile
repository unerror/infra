# Copyright (c) 2021 Tailscale Inc & AUTHORS All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

ARG TAILSCALE_VERSION="v1.16"
FROM ghcr.io/tailscale/tailscale:${TAILSCALE_VERSION}
COPY run.sh /run.sh
RUN chmod a+x /run.sh
CMD "/run.sh"
