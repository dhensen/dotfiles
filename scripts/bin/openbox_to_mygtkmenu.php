#!/usr/bin/php
<?php

$f = file("php://stdin");

function get_action($line)
{
    preg_match("/\[([a-z]+)\]/", $line, $matches);
    $actions = ['submenu', 'exec', 'end'];
    $action = in_array($matches[1], $actions) ? $matches[1] : null;
    return $action;
}

function get_name($line)
{
    preg_match("/\(([A-Za-z0-9 \-&\(\)\+]+)\)/", $line, $matches);
    if (isset($matches[1]) && !is_null($matches[1])) {
        return $matches[1];
    }

    return null;
}

function get_cmd($line)
{
    preg_match("/\{(.*)\}/", $line, $matches);
    if (isset($matches[1]) && !is_null($matches[1])) {
        return $matches[1];
    }

    return null;
}

class Menu
{
    private $name;
    private $cmd;
    private $parent;
    private $contents = [];

    public function __construct($name, $cmd = null, $parent = null)
    {
        $this->name = $name;
        $this->cmd = $cmd;
        $this->parent = $parent;
    }

    public function add(Menu $menu)
    {
        $this->contents[] = $menu;
    }

    public function getChildren()
    {
        return $this->contents;
    }

    public function submenu($name)
    {
        $menu = new Menu($name, null, $this);
        $this->add($menu);
        return $menu;
    }

    public function end()
    {
        return $this->getParent();
    }

    public function exec($name, $cmd)
    {
        $menu = new Menu($name, $cmd, $this);
        $this->add($menu);
        return $this;
    }

    public function getName()
    {
        return $this->name;
    }

    public function getCmd()
    {
        return $this->cmd;
    }

    public function getParent()
    {
        return $this->parent;
    }

    public function is_submenu()
    {
        return $this->cmd == null && count($this->contents) > 0;
    }
}

$rootmenu = $menu = new Menu('root-menu', null, null);
foreach($f as $line) {
    $action = get_action($line);
    $name = get_name($line);
    $cmd = get_cmd($line);

    $menu = call_user_func([$menu, $action], $name, $cmd);
}


class MenuPrinter
{
    const INDENT_SIZE = 1;
    private $indent;

    public function __construct()
    {
        $this->indent = 0;
    }

    public function print($string)
    {
        printf("%s%s\n", str_repeat("\t", $this->indent * MenuPrinter::INDENT_SIZE), $string);
    }

    public function print_menu($menu)
    {
        if ($menu->is_submenu()) {
            $this->print(sprintf("Submenu = %s", $menu->getName()));
            $this->indent++;
            $this->print("");
            $this->print("icon = NULL");
            $this->print("");
            foreach ($menu->getChildren() as $child)
            {
                $this->print_menu($child);
            }
            $this->indent--;
        } else {
            $this->print(sprintf("item = %s", $menu->getName()));
            $this->print(sprintf("cmd = %s", $menu->getCmd()));
            $this->print("icon = NULL");
            $this->print("");
        }
    }
}

$printer = new MenuPrinter();
foreach ($rootmenu->getChildren() as $topmenu) {
    $printer->print_menu($topmenu);
}
