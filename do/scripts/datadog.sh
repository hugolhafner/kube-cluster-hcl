#!/bin/bash

kubectl -n istio-system patch service istio-telemetry --patch "$(cat<<EOF
metadata:
    annotations:
        ad.datadoghq.com/endpoints.check_names: '["istio"]'
        ad.datadoghq.com/endpoints.init_configs: '[{}]'
        ad.datadoghq.com/endpoints.instances: |
            [
              {
                "istio_mesh_endpoint": "http://%%host%%:42422/metrics",
                "mixer_endpoint": "http://%%host%%:15014/metrics",
                "send_histograms_buckets": true
              }
            ]
EOF
)"

kubectl -n istio-system patch service istio-galley --patch "$(cat<<EOF
metadata:
    annotations:
        ad.datadoghq.com/endpoints.check_names: '["istio"]'
        ad.datadoghq.com/endpoints.init_configs: '[{}]'
        ad.datadoghq.com/endpoints.instances: |
            [
              {
                "galley_endpoint": "http://%%host%%:15014/metrics",
                "send_histograms_buckets": true
              }
            ]
EOF
)"

kubectl -n istio-system patch service istio-pilot --patch "$(cat<<EOF
metadata:
    annotations:
        ad.datadoghq.com/endpoints.check_names: '["istio"]'
        ad.datadoghq.com/endpoints.init_configs: '[{}]'
        ad.datadoghq.com/endpoints.instances: |
            [
              {
                "pilot_endpoint": "http://%%host%%:15014/metrics",
                "send_histograms_buckets": true
              }
            ]
EOF
)"

kubectl -n istio-system patch service istio-citadel --patch "$(cat<<EOF
metadata:
    annotations:
        ad.datadoghq.com/endpoints.check_names: '["istio"]'
        ad.datadoghq.com/endpoints.init_configs: '[{}]'
        ad.datadoghq.com/endpoints.instances: |
            [
              {
                "citadel_endpoint": "http://%%host%%:15014/metrics",
                "send_histograms_buckets": true
              }
            ]
EOF
)"