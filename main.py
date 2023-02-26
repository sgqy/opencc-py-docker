#!/usr/bin/env python3

from flask import Flask, request

from opencc import OpenCC

app = Flask(__name__)


@app.route('/conv', methods=['POST'])
def cmp():
    '''
    post json object { a: sentence to compare, b: sentence to compare }
    '''
    try:
        data = request.get_json()
        mod = data.get('mod')
        txt = data.get('txt')

        cc = OpenCC(mod)

        return {
            'code': 0,
            'msg': 'success',
            'data': {
                'text': cc.convert(txt),
                'mode': mod,
            },
        }
    except Exception as ec:
        return {
            'code': -2,
            'msg': repr(ec),
            'data': None,
        }, 500


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
