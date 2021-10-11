ma1sd
=====
Federated Matrix Identity Server (formerly fork of kamax/mxisd)

Current chart version is `0.1.0`

Source code can be found [here](https://github.com/ma1uta/ma1sd)



## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| config.dns.overwrite.homeserver.client | list | `[]` |  |
| config.forward.servers[0] | string | `"matrix.org"` |  |
| config.key.path | string | `"/etc/ma1sd/signing.key"` |  |
| config.logging.app | string | `"info"` |  |
| config.logging.root | string | `"info"` |  |
| config.matrix.domain | string | `"example.com"` |  |
| config.server.name | string | `"matrix.example.com"` |  |
| config.server.port | int | `8090` |  |
| config.server.publicUrl | string | `"https://matrix.example.com"` |  |
| config.storage.backend | string | `"sqlite"` |  |
| config.storage.provider.sqlite.database | string | `"/var/lib/ma1sd/ma1sd.db"` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"ma1uta/ma1sd"` |  |
| image.tag | string | `"2.3.0"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.enabled | bool | `false` |  |
| persistence.existingClaim | string | `nil` |  |
| persistence.size | string | `"1Gi"` |  |
| persistence.storageClassName | string | `nil` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.port | int | `8090` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `nil` |  |
| signing_key | string | `nil` | Generate with `python3 -e "import string; import random; import sys; from signedjson.key import generate_signing_key, write_signing_keys; write_signing_keys(sys.stdout,(generate_signing_key("a_" + "".join(random.SystemRandom().choice(string.ascii_letters) for _ in range(4))),))"` or use synapse signing key |
| tolerations | list | `[]` |  |
