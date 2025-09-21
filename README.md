

## Kubernetes in Docker (KinD) Rootless

- https://kind.sigs.k8s.io/docs/user/rootless/
- `systemd-run --scope --user -p "Delegate=yes" kind create cluster`


## Notes

> We also have the common `SQLite`


- The [PEV2](./static/index.html) is a page with **sql plan analyser**
alternative to `EXPLAIN` command and [explain depesz](https://explain.depesz.com/s/g14A)
or even [pgbadger](https://blog.4linux.com.br/analisando-a-performance-no-postgres-com-o-pgbadger/) 


- Install `DuckDB` with:
```sh
curl https://install.duckdb.org | sh

export PATH='/home/ppcamp/.duckdb/cli/latest':$PATH
```
