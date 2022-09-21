# ZeroTier Orb


[![CircleCI Build Status](https://circleci.com/gh/orbiously/zerotier-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/orbiously/zerotier-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/orbiously/zerotier.svg)](https://circleci.com/orbs/registry/orb/orbiously/zerotier) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/orbiously/zerotier-orb/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)



This orb will allow you to connect the build-host to a ZeroTier network, communicate with any other member of the ZeroTier network, and alternatively use another ZeroTier member as a jump/bastion host.

_Note that even if you choose to route **all** Internet via the ZeroTier member acting as a jump/bastion host (`full-vpn: true`), traffic between the build-agent and other CircleCI components/services, as well as, DNS requests **will not** be routed through the ZeroTier network._

**This is an “executor-agnostic” orb; there is only one set of commands which can be used on any _supported_ executor. The orb’s underlying code handles the OS/platform detection, and runs the appropriate OS-specific bash commands.**

---

## Executor support

| Linux (`machine`)  | Windows | macOS  | Docker |
| :---: | :---: | :---: | :---: |
| :white_check_mark:  | :white_check_mark:  | :white_check_mark:  | :x:  |


## Requirements

Before attempting to use this ZeroTier orb:

- You should have access to a ZeroTier network with at least **one online** member/node.

    - The ZeroTier IP address must be referenced via the `zerotier-remote-member` parameter of the orb's connect command.
    
- Ensure you have stored the ZeroTier network ID **and** a ZeroTier [API access token](https://my.zerotier.com/account) in respective environment variables  (either in the [project settings](https://circleci.com/docs/env-vars#setting-an-environment-variable-in-a-project) or in an [organization context](https://circleci.com/docs/env-vars#setting-an-environment-variable-in-a-context)).

    - By default, the orb's `connect` command expects the ZeroTier netword ID and the ZeroTier API access token to be stored in environment variables respectively named `ZT_NET_ID` and `ZT_API_TOKEN`, however you can opt to store them in custom-named environment variables; in such case, the environment variables' names **must be** passed to the orb's `connect` command via the `net-id-var` and `api-token-var` parameters.

- If you want to route traffic to specific IPs via the Zerotier member specified in the `zerotier-remote-member` parameter, you'll need the [appropriate managed route](https://zerotier.atlassian.net/wiki/spaces/SD/pages/224395274/Route+between+ZeroTier+and+Physical+Networks).

- If you want to route **all Internet traffic** via the Zerotier member specified in the `zerotier-remote-member` parameter, make sure you've added a [(managed) default route]((https://zerotier.atlassian.net/wiki/spaces/SD/pages/7110693/Overriding+Default+Route+Full+Tunnel+Mode)).


## Features

This orb has 2 commands:
- `connect`
- `disconnect`

There are **no job or executor** defined in this orb.


### Commands

The `connect` command will:
- Download/Install ZeroTier (if needed).
- Start the ZeroTier service (if needed).
- Make the build-host join the specified ZeroTier network.
- Authorize the member via a request to the ZeroTier API.
- [**Only if you use `full-vpn: true`**] Add CircleCI-specific routes to prevent traffic between the build-agent and other CircleCI components/services, as well as, DNS requests from being routed through the ZeroTier network.

The `disconnect` command will:
- Make the build-host leave the ZeroTier network.
- Stop the ZeroTier service.
- [**Only if you use `store-log: true`**] Generate a debug settings dump and store it as an artifact.


## Caveats & limitations

- The orb adds route to prevent traffic between the build-agent and other CircleCI components/services, as well as, DNS requests from being routed through the ZeroTier network.

  This is necessary to avoid networking issues when you routing all Internet traffic through the ZeroTier network.
  
  **However, these routes are based on the current architecture of the CircleCI build-environement, which is subject to change over time thus rendering the aforementioned routes exclusions obsolete and ineffective.**

- When choosing your ZeroTier network IP range, make sure it doesn't conflict with the build-host's existing network/routing configuration.

- The `docker` executor is not supported (due to [limitations of unprivileged LXC containers](https://circleci.com/blog/vpns-and-why-they-don-t-work/) used in CircleCI).


## Resources

[CircleCI Orb Registry Page](https://circleci.com/orbs/registry/orb/orbiously/zerotier) - The official registry page of this orb for all versions, executors, commands, and jobs described.

[CircleCI Orb Docs](https://circleci.com/docs/2.0/orb-intro/#section=configuration) - Docs for using, creating, and publishing CircleCI Orbs.

## Important note regarding support

This is an [**uncertified** orb](https://circleci.com/docs/orbs-faq#using-uncertified-orbs); it is **neither tested nor verified by CircleCI**. Therefore CircleCI **will not** be in a position to assist you with using this orb, or troubleshooting/resolving any issues you might encouter while using this orb.

Should you have questions or encounter an issue while using this orb, please:

1. Refer to the "[Caveats & limitations](https://github.com/orbiously/zerotier-orb/README.md#caveats--limitations)" section.
2. Check if there is a similar [existing question/issue](https://github.com/orbiously/zerotier-orb/issues). If so, you can add details about your instance of the issue.
3. Visit the [Orb category of the CircleCI Discuss community forum](https://discuss.circleci.com/c/orbs). 
4. If none of the above helps, [open your own issue](https://github.com/orbiously/zerotier-orb/issues/new/choose) with a **detailled** description.

## Contribute

You are more than welcome to contribute to this orb by adding features/improvements or fixing open issues. To do so, please create [pull requests](https://github.com/orbiously/zerotier-orb/pulls) against this repository, and make sure to provide the requested information.