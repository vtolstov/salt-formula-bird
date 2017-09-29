import yaml

def pad(s,c=0):
    ret = ''
    for x in range(0, c):
        ret += ' '
    return ret+s

def config(cfg={}, indent=0):
    ret = ''
    for key in sorted(cfg.keys()):
        if type(cfg[key]) is int:
            ret = '{}{} {};\n'.format(ret, pad(key, indent), cfg[key])
        elif type(cfg[key]) is bool:
            if cfg[key]:
                ret = '{}{} on;\n'.format(ret, pad(key, indent))
            else:
                ret = '{}{} off;\n'.format(ret, pad(key, indent))
        elif type(cfg[key]) is list:
            if key == 'include':
                for value in cfg[key]:
                    ret = '{}{} "{}";\n'.format(ret, pad(key, indent), value)
                ret = '{}\n'.format(ret)
            elif key == 'syslog':
                ret = '{}{} {{ {} }};\n'.format(ret, pad(key, indent), ', '.join(cfg[key]))
            else:
                ret = '{}{} {};\n'.format(ret, pad(key, indent), (', '.join('"' + value + '"' for value in cfg[key])))
        elif type(cfg[key]) is dict:
            ret = '{}{} {{\n'.format(ret, pad(key, indent))
            ret = '{}{}'.format(ret, config(cfg[key], indent=indent+4))
            ret = '{}{}\n\n'.format(ret, pad('};', indent))
    return ret


data = yaml.safe_load(file('pillars/environments/mn_clodo_ru/compute/bird.sls')).get('bird').get('ipv4')
print config(data)
