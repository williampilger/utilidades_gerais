import shlex

class EnvLoader:
    def __init__(self, env_file_path):
        self.env_vars = {}
        with open(env_file_path, 'r') as file:
            for line in file:
                line = line.strip()
                if line and not line.startswith('#'):
                    key, value = line.split('=', 1)
                    self.env_vars[key] = shlex.quote(value).strip("'")

    def get_var(self, name, default=None, var_type=str):
        value = self.env_vars.get(name)
        if value is None:
            return default
        if var_type is bool:
            return value.lower() in ['true', '1', 't', 'y', 'yes']
        elif var_type is int:
            return int(value)
        elif var_type is float:
            return float(value)
        else:  # Assume str by default
            return value
