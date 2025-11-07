#!/bin/bash

function remove_wifi() {
  local target=$1
  #去除依赖
  sed -i 's/\(ath11k-firmware-[^ ]*\|ipq-wifi-[^ ]*\|kmod-ath11k-[^ ]*\)//g' ./target/linux/qualcommax/Makefile
  sed -i 's/\(ath11k-firmware-[^ ]*\|ipq-wifi-[^ ]*\|kmod-ath11k-[^ ]*\)//g' ./target/linux/qualcommax/${target}/target.mk
  sed -i 's/\(ath11k-firmware-[^ ]*\|ipq-wifi-[^ ]*\|kmod-ath11k-[^ ]*\)//g' ./target/linux/qualcommax/image/${target}.mk
  sed -i 's/\(ath10k-firmware-[^ ]*\|kmod-ath10k [^ ]*\|kmod-ath10k-[^ ]*\)//g' ./target/linux/qualcommax/image/${target}.mk
  #删除无线组件
  rm -rf package/network/services/hostapd
  rm -rf package/firmware/ipq-wifi
}

function generate_config() {
  config_file=".config"
  #如配置文件已存在
  cat $GITHUB_WORKSPACE/Config/${WRT_CONFIG}.txt $GITHUB_WORKSPACE/Config/GENERAL.txt  > $config_file
  local target=$(echo $WRT_ARCH | cut -d'_' -f2)

  #删除wifi依赖
  if [[ "$WRT_CONFIG" == *"NOWIFI"* ]]; then
    remove_wifi $target
  fi
}
