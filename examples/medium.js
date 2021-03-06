// Generated by BUCKLESCRIPT VERSION 3.0.0, PLEASE EDIT WITH CARE
'use strict';

var List = require("bs-platform/lib/js/list.js");
var Curry = require("bs-platform/lib/js/curry.js");
var Dynamodb = require("../src/dynamodb.js");
var BsCallback = require("bs-callback/src/bsCallback.js");

var uuid = (function() {
  require("uuid/v1")();
});

var partial_arg = Dynamodb.Specs[/* string */1];

var partial_arg$1 = Dynamodb.Specs[/* string */1];

function specs_000(param) {
  return partial_arg(/* None */0, "id", param);
}

var specs_001 = /* :: */[
  (function (param) {
      return partial_arg$1(/* None */0, "key", param);
    }),
  /* [] */0
];

var specs = /* :: */[
  specs_000,
  specs_001
];

var specs$1 = List.fold_left((function (spec, str) {
        return Curry._1(str, spec);
      }), Dynamodb.Specs[/* make */0](/* () */0), specs);

var Definition = /* module */[
  /* name */"Media",
  /* hashKey */"id",
  /* timestamps */true,
  /* specs */specs$1,
  /* table_name */"media"
];

var Model = Dynamodb.Make(Definition);

var create = Model[1];

var update = Model[3];

function create$1(params) {
  params.id = uuid();
  return Curry._1(create, params);
}

function set_state(model, state) {
  var attrs = model.attrs;
  attrs.state = state;
  var partial_arg = Curry._1(update, attrs);
  return (function (param) {
      return BsCallback.$great$great(partial_arg, (function (model) {
                    if (model) {
                      var partial_arg = model[0];
                      return (function (param) {
                          return BsCallback.$$return(partial_arg, param);
                        });
                    } else {
                      var partial_arg$1 = new Error("Inconsistent state update (should not happen)");
                      return (function (param) {
                          return BsCallback.fail(partial_arg$1, param);
                        });
                    }
                  }), param);
    });
}

var create_table = Model[0];

var get = Model[2];

exports.create_table = create_table;
exports.create = create$1;
exports.get = get;
exports.set_state = set_state;
exports.update = update;
/* uuid Not a pure module */
