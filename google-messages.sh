#!/usr/bin/bash

# Merge the policies with the host ones.
policy_root=/etc/opt/chrome/policies

for policy_type in managed recommended enrollment; do
  policy_dir="$policy_root/$policy_type"
  mkdir -p "$policy_dir"

  if [[ -d "/run/host/$policy_root/$policy_type" ]]; then
    find "/run/host/$policy_root/$policy_type" -type f -name '*' \
      -exec ln -sf '{}' "$policy_root/$policy_type" \;
  fi
done

export LD_LIBRARY_PATH="/app/bin:/app/lib:/usr/lib:/usr/lib64:/usr/local/lib:/usr/local/lib64:/app/GoogleMessages/:$LD_LIBRARY_PATH"
export PATH="/app/GoogleMessages:/app/bin:/usr/bin:/usr/local/bin:/usr/sbin:/usr/local/sbin:$PATH"
exec zypak-wrapper /app/GoogleMessages/GoogleMessages --enable-features=VaapiVideoDecoder,UseOzonePlatform --disable-features=UseChromeOSDirectVideoDecoder "$@"
