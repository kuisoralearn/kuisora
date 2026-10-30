import {DatabaseSync} from 'node:sqlite';
import {readFileSync} from 'node:fs';
export const sqlite=new DatabaseSync(':memory:');
sqlite.exec(readFileSync(new URL('../drizzle/0000_wonderful_apocalypse.sql',import.meta.url),'utf8'));
let request;
export function setRequest(r){request=r}
export async function headers(){return request.headers}
export async function cookies(){return {get(name){const value=request.headers.get('cookie')?.split('; ').find(x=>x.startsWith(name+'='))?.slice(name.length+1);return value?{value}:undefined}}}
export function redirect(){throw new Error('Unexpected redirect')}
export const assets=new Map();
export const env={DB:{prepare(sql){let args=[];const binding={bind(...values){args=values;return binding},async first(){return sqlite.prepare(sql).get(...args)||null},async all(){return {results:sqlite.prepare(sql).all(...args)}},async run(){return {meta:sqlite.prepare(sql).run(...args)}}};return binding}},BUCKET:{async head(key){return assets.get(key)||null},async get(key){return assets.get(key)||null}}};
