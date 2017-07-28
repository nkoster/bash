#!/bin/bash

[[ $# -lt 1 ]] && exit 1

P=${1%/}

mkdir -p $P/src/main/scala/Hello
mkdir -p $P/src/test/scala

[[ ! -f $P/build.sbt ]] && cat >$P/build.sbt<<\EOF
lazy val root = (project in file(".")).
  settings(
    scalaVersion := "2.11.8"
  )

libraryDependencies ++= Seq(
  "org.scalatest" %% "scalatest" % "latest.release" % "test"
)
EOF

[[ ! -f $P/src/main/scala/Hello/HelloWorld.scala ]] && \
   cat >$P/src/main/scala/Hello/HelloWorld.scala<<\EOF
package Hello

object HelloWorld {

  def hello(s: String = "World") = {
    "Hello, " + s + "!"
  }

  def main(args: Array[String]): Unit = {
    println(hello())
  }

}
EOF

[[ ! -f $P/src/test/scala/HelloWorldTest.scala ]] && \
   cat >$P/src/test/scala/HelloWorldTest.scala<<\EOF
import org.scalatest.{Matchers, FunSuite}
import Hello.HelloWorld

class HelloWorldTest extends FunSuite with Matchers {

  test("Without name") {
    HelloWorld.hello() should be ("Hello, World!")
  }

  test("with name") {
    HelloWorld.hello("Jane") should be ("Hello, Jane!")
  }

  test("with umlaut name") {
    HelloWorld.hello("Jürgen") should be ("Hello, Jürgen!")
  }

}
EOF
