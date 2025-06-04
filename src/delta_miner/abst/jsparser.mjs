import { parse } from '@babel/parser';
import fs from 'fs';
import process from 'process';

const options = {
    sourceType: 'module',
    plugins: ['estree']
};

// process.argv は process オブジェクトのプロパティとして直接アクセスできます
const filePath = process.argv[2];
const code = fs.readFileSync(filePath, 'utf8');

const ast = parse(code, options);
console.log(JSON.stringify(ast));
