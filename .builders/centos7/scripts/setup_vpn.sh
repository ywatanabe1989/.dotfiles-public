#!/bin/bash
# https://pgv.docbase.io/posts/672052

sudo yum update -y
sudo yum install libreswan -y

sudo yum install epel-release -y

yum install xl2tpd -y

yum install NetworkManager-l2tp -y

yum install NetworkManager-l2tp-gnome -y

reboot

## ネットワーク設定
# アクティヴィティ　＞　検索ワード「設定」or 「setting」＞　設定　＞　ネットワーク

## VPNの追加
# VPN「＋」押下、VPN設定を追加　＞　Layer 2 Tunneling Protocol (L2TP)を選択
# 名前：（設定に表示される名前）を適当につける
# 一般
# ゲートウェイ：PGVのグローバルIP（管理者に聞いてください）を入力する
# ユーザ認証
# タイプ：パスワード
# ユーザ名：管理者から与えられた各自のVPNユーザ名を入力する
# パスワード：管理者から与えられた各自のVPNユーザパスワードを入力する
# NTドメイン：未入力のまま（デフォルト）

##IPsec Settings
# Enable IPsec tunnel to L2TP host: Enable
# Machine Authentication
# Type: Pre-shared key(PSK) ....共通鍵認証
# Pre-shared key: 管理者から与えられたVPN共通鍵パスワードを入力する
# Advanced
# Remote ID: 192.168.1.1(PGV社内ルータ、デフォルトルート）
# Phase1 Algorithms:未入力のまま（デフォルト）
# Phase2 Algorithms:未入力のまま（デフォルト）
# 他チェックボックス:Disableのまま（デフォルト）

## L2TP PPP Options
# 全てデフォルト（下記イメージの通り）
