#!/usr/bin/env bash
# rapl-cap.sh — clamp package power limits (UX3405MA)
set -euo pipefail

RAPL=/sys/class/powercap/intel-rapl:0
PL1=20000000   # 20 W sustained
PL2=35000000   # 35 W burst

nset() {
  local key="$1"
  local new="$2"
  local cur=`cat $1`
  echo "Setting $key from $cur to $new"
  echo "$new" > "$key"
}

nset "/sys/devices/platform/asus-nb-wmi/throttle_thermal_policy" 1

nset "$RAPL/constraint_0_power_limit_uw" $PL1
nset "$RAPL/constraint_1_power_limit_uw" $PL2

# MMIO interface shadows the MSR one on Meteor Lake; cap both
MMIO=/sys/class/powercap/intel-rapl-mmio:0
if [[ -d $MMIO ]]; then
  nset "$MMIO/constraint_0_power_limit_uw" $PL1
  nset "$MMIO/constraint_1_power_limit_uw" $PL2
fi
