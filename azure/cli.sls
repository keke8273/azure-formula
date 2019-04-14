# vim: ft=sls

{% from "azure/map.jinja" import azure with context %}

azure_cli_dependencies:
  pkg.installed:
    - pkgs:
      - curl
      - gpg

azure_cli:
  cmd.run:
    - name: "curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null"
  pkgrepo.managed:
    {% if grains['os_family'] == 'Debian' %}
      {%set repo_suffix = grains['oscodename'] %}
    {% endif %}
    - file: {{azure.deb_apt_source}}
    - name: deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ {{repo_suffix}} main
    - require_in:
      - pkg: azure_cli
  pkg.installed:
    - pkgs:
      - {{azure.azure_cli_pkg}}
