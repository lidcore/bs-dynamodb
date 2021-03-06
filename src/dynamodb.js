// Generated by BUCKLESCRIPT VERSION 3.0.0, PLEASE EDIT WITH CARE
'use strict';

var Joi = require("joi");
var Curry = require("bs-platform/lib/js/curry.js");
var BsCallback = require("bs-callback/src/bsCallback.js");

var dynamodb = require("dynamodb")
;

var spec_set = (function(obj,lbl,value){
    obj[lbl] = value;
    return obj;
  });

function make_spec(fn, $staropt$star, name, spec) {
  var required = $staropt$star ? $staropt$star[0] : true;
  var spec_value = Curry._2(fn, Joi, /* () */0);
  var spec_value$1 = required ? spec_value.required() : spec_value;
  return spec_set(spec, name, spec_value$1);
}

function string(param, param$1, param$2) {
  return make_spec((function (prim, _) {
                return prim.string();
              }), param, param$1, param$2);
}

function obj(param, param$1, param$2) {
  return make_spec((function (prim, _) {
                return prim.object();
              }), param, param$1, param$2);
}

function Make(Def) {
  var make_model_class = function () {
    var definition = {
      hashKey: Def[/* hashKey */1],
      timestamps: Def[/* timestamps */2],
      schema: Def[/* specs */3]
    };
    return dynamodb.define(Def[/* table_name */4], definition);
  };
  var model_class = make_model_class(/* () */0);
  var create_table = function (param) {
    model_class.createTable(param);
    return /* () */0;
  };
  var create = function (param, param$1) {
    model_class.create(param, param$1);
    return /* () */0;
  };
  var to_opt = function (value) {
    var partial_arg = (value == null) ? /* None */0 : [value];
    return (function (param) {
        return BsCallback.$$return(partial_arg, param);
      });
  };
  var get = function (id) {
    return (function (param) {
        return BsCallback.$great$great((function (param) {
                      model_class.get(id, param);
                      return /* () */0;
                    }), to_opt, param);
      });
  };
  var update = function (attributes) {
    return (function (param) {
        return BsCallback.$great$great((function (param) {
                      model_class.update(attributes, param);
                      return /* () */0;
                    }), to_opt, param);
      });
  };
  return /* module */[
          /* create_table */create_table,
          /* create */create,
          /* get */get,
          /* update */update
        ];
}

function update_credentials(prim) {
  dynamodb.AWS.config.update(prim);
  return /* () */0;
}

function Specs_000() {
  return { };
}

var Specs = [
  Specs_000,
  string,
  obj
];

exports.update_credentials = update_credentials;
exports.Specs = Specs;
exports.Make = Make;
/*  Not a pure module */
