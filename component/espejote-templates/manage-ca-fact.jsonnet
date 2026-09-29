local esp = import 'espejote.libsonnet';
local src =
  local srcs = esp.context().source;
  assert std.length(srcs) == 1 : 'Expected source context to have length 1';
  srcs[0];
{
  apiVersion: 'v1',
  kind: 'ConfigMap',
  metadata: {
    name: 'capi-talos-ca-fact',
    namespace: 'syn',
    labels: {
      'app.kubernetes.io/managed-by': 'espejote',
      'steward.syn.tools/include-facts': '',
    },
  },
  data: {
    facts: std.manifestJsonMinified({
      talosAPICertificateAuthorityData: src.data['tls.crt'],
    }),
  },
}
