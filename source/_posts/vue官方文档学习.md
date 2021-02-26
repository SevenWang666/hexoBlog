## 0.0.Vue.js是什么
是一套用于构建用户界面的渐进式框架。与其它大型框架不同的是，Vue 被设计为可以自底向上逐层应用。Vue 

的核心库只关注视图层，不仅易于上手，还便于与第三方库或既有项目整合。另一方面，当与现代化的工具链以及各种支持类库结合使用时，Vue 也完全能够为复杂的单页应用提供驱动。

## 特点
* 声明式渲染 ：vue可以采用简洁的模板语法来声明式的将数据渲染为DOM
* 条件循环:可以将数据绑定到文本和属性，也可以将数据绑定到 DOM **结构**。而且，Vue 也提供一个强大的过渡效果系统，可以在 Vue 插入/更新/删除元素时，自动使用[过渡效果](https://vue.docschina.org/v2/guide/transitions.html)。
* 处理用户输入:使用 `v-on` 指令 来增加事件监听器，触发事件后会调用 Vue 实例中 methods 下定义的方法


## 组件化应用构建
允许我们使用小型、独立和通常可复用的组件构建大型应用，九层之台起于垒土，千里之行始于足下。
tips:组件必须用在Vue环境下，才会被识别。
vue应用程序由一个使用new Vue创建的Vue根实例、嵌套的树结构和可复用的组件 组成。



## 组件的应用模板

```javascript
let myvue = new Vue({
    el:".container",
    store:vuex_store, //注入到vue
    router:routerConfig,
});
```



## 数据与方法
当一个 Vue 实例被创建时，它向 Vue 的响应式系统中加入了其 data 对象中能找到的所有的属性。当这些属性的值发生改变时，视图将会产生“响应”，即匹配更新为新的值。
tips:只有当实例创建时，data中的属性才是响应式的。
可以使用Object.freeze()方法阻止在data对象中属性的修改。

## 实例生命周期钩子

Mustache 语法不能作用在HTML特性中，遇到这种情况使用v-bind指令.
**绑定简单的属性值**

```html
{{ number + 1 }}

{{ ok ? 'YES' : 'NO' }}

{{ message.split('').reverse().join('') }}

<div v-bind:id="'list-' + id"></div>
```

## 指令
v-bind v-on v-if 等等
简写:v-bind :
v-on @  等等

* v-else:顾名思义，v-else就是JavaScript中else的意思，必须跟着v-if或v-show，充当else功能，tips，当将v-show用在组件上时，因为指令的优先级v-else会出现问题，所以不要这样做`<custom-component v-show="condition"></custom-component><p v-else></p>`

* v-model  在用户输入事件中更新数据。在v-model后面可以添加多个参数(number、lazy、debounce、trim)。

* v-for 基于源数据重复渲染元素，形式“item in items”(items 是数据数组，item是当前数组元素的别名)，也可以是"item of items"形式

  使用v-for,将得到一个特殊的作用域，类似于angularjs的 隔离作用域，需要明确指定props属性传递数据，否则在组件内将获取不到数据。例

  ```html
  <my-item v-for="item in items" :item="item" :index="$index">
  <slot>{{item.text}}</slot>
  </my-item>
  ```

  Vue.js包装了被观察数组的变异方法，他们能触发视图更新，被包装的方法有：push(),pop(),shift(),unshift(),splice(),sort(),reverse();vuejs重写了这些方法，触发了一次notify，还增加了$set,$remove，观测变化。用法如下

  ```javascript
  this.items.$set(0,{childMsg:"changai"})
  this.items.$remove(item);
  //第二行代码等同于如下代码
  var index=this.items.indexof(item);
  if(index!==-1){
      this.items.splice(index,1);
  }
  ```

  也可以用filter,concat,slice方法，返回的数组将是一个不同的实例，我们可以用新的数据替换原来的数组

  v-for可以遍历一个对象,每个重复的实例都将有一个特殊的属性$key,或者给对象的键值提供一个别名。，vue.js增加了三种方法$add(key,value),$set(key,value)和$delete(key),这些方法可以用来添加和删除属性，触发视图更新

  **filterBy**  语法：filterBy searchKey [in dataKey ...]

  **orderBy**  语法: orderBy sortKey[reverseKey]

```html
<!--v-for和filterBy配合使用-->
<li v-for="user in users | filterBy searchText in 'name'">{{user.name}}</li>
<!--v-for和orderBy配合使用-->
<li v-for="user in users | orderBy field reverrse"></li>
```

## 响应式系统

### 数组变化检测

**变化数组的方法**：Vue 将观察数组(observed array)的变化数组方法(mutation method)包裹起来，以便在调用这些方法时，也能够触发视图更新。

* push()
* pop()
* shift()
* unshift()
* sort
* reverse
* splice

这些方法都会改变原始数组，相比之下还有非变化数组方法，例如 `filter()`, `concat()` 和 `slice()`，这些方法都不会直接修改操作原始数组，而是**返回一个新数组**。当使用非变化数组方法时，可以将旧数组替换为新数组：

由于 JavaScript 的限制，Vue 无法检测到以下数组变动：

1. 当你使用索引直接设置一项时，例如 `vm.items[indexOfItem] = newValue`
2. 当你修改数组长度时，例如 `vm.items.length = newLength`

```html
var vm = new Vue({
  data: {
    items: ['a', 'b', 'c']
  }
})
vm.items[1] = 'x' // 不是响应的
vm.items.length = 2 // 不是响应的
```

可以通过以下方法

```javascript
// Vue.set
Vue.set(vm.items, indexOfItem, newValue)
// Array.prototype.splice
vm.items.splice(indexOfItem, 1, newValue)
vm.$set(vm.items, indexOfItem, newValue)
vm.items.splice(newLength)

```

Vue.set(object, key, value)

有时，你想要向已经存在的对象上添加一些新的属性，例如使用 `Object.assign()` 或 `_.extend()` 方法。在这种情况下，应该创建一个新的对象，这个对象同时具有两个对象的所有属性，因此，改为：

```
Object.assign(vm.userProfile, {
  age: 27,
  favoriteColor: 'Vue Green'
})
//可以通过如下方式，添加新的响应式属性
vm.userProfile = Object.assign({}, vm.userProfile, {
  age: 27,
  favoriteColor: 'Vue Green'
})
```







## computed
当Mustache 语法中出现比较复杂的逻辑时，可以使用computed属性来维护和简化模板。
```
<div id="example">
  <p>初始 message 是："{{ message }}"</p>
  <p>计算后的翻转 message 是："{{ reversedMessage }}"</p>
</div>
var vm = new Vue({
  el: '#example',
  data: {
    message: 'Hello'
  },
  computed: {
    // 一个 computed 属性的 getter 函数
    reversedMessage: function () {
      // `this` 指向 vm 实例
      return this.message.split('').reverse().join('')
    }
    fullName: {
    // getter 函数
    get: function () {
      return this.firstName + ' ' + this.lastName
    },
    // setter 函数
    set: function (newValue) {
      var names = newValue.split(' ')
      this.firstName = names[0]
      this.lastName = names[names.length - 1]
    }
 	 }
  }
})
```


## computed缓存 vs method方法
computed 属性会基于它所依赖的数据进行缓存。每个 computed 属性，只有在它所依赖的数据发生变化时，才会重新取值(re-evaluate)。这就意味着，只要 message 没有发生变化，多次访问 computed 属性 reversedMessage，将会立刻返回之前计算过的结果，而不必每次都重新执行函数。
method:每当触发重新渲染(re-render)时，method 调用方式将总是再次执行函数。

## watcher
一般用于在数据变化响应时，执行异步操作，或高性能消耗操作，例如可以限制ajax请求频率，  使用 `watch` 选项，可以使我们执行一个限制执行频率的（访问一个 API 的）异步操作，并且不断地设置中间状态，直到我们获取到最终的 answer 数据之后，才真正执行异步操作。而 computed 属性无法实现。

除了 `watch` 选项之外，还可以使用命令式(imperative)的 [vm.$watch](https://vue.docschina.org/v2/api/#vm-watch) API。  



## class和style绑定
语法
```html
<div v-bind:class="{active：isActive}"><div>
多个属性共存，对象语法
<div class="static"
     v-bind:class="{ active: isActive, 'text-danger': hasError }">
</div>
数组语法
<div v-bind:class="[activeClass, errorClass]"></div>
data: {
  activeClass: 'active',
  errorClass: 'text-danger'
}
被渲染为:
<div class="active text-danger"></div>
根据条件切换class列表中的某个class，可以通过三元表达式实现。
<div v-bind:class="[isActive ? activeClass : '', errorClass]"></div>
在数组中使用对象语法。
<div v-bind:class="[{ active: isActive }, errorClass]"></div>

在style使用 对象语法
<div v-bind:style="{ color: activeColor, fontSize: fontSize + 'px' }"></div>
<div v-bind:style="styleObject"></div>
data: {
  styleObject: {
    color: 'red',
    fontSize: '13px'
  }
}
数组语法
<div v-bind:style="[baseStyles, overridingStyles]"></div>

```


## v-if和v-show比较
v-if在切换时有更高的性能开销
v-show在初始时有更高的性能开销.

v-if和v-for 一起使用时，v-for比v-if具有更高的优先级。这点与angualrjs中相反，在同一级元素中在angularjs中v-if的优先级更高，如果为false，将不显示v-for中的数据。

## 事件处理

监听事件，定义在methods对象中的事件处理器，定义在行内的事件处理器

按键事件修饰符 
enter,tab,delete,esc,space,up,down,left,right
自定义按键修饰符,通过全局config.keyCodes

```html
<!-- 停止点击事件冒泡 -->
<a v-on:click.stop="doThis"></a>

<!-- 提交事件不再重新载入页面 -->
<form v-on:submit.prevent="onSubmit"></form>

<!-- 修饰符可以链式调用 -->
<a v-on:click.stop.prevent="doThat"></a>

<!-- 只有修饰符 -->
<form v-on:submit.prevent></form>

<!-- 添加事件监听器时，使用事件捕获模式 -->
<!-- 也就是说，内部元素触发的事件先在此处处理，然后才交给内部元素进行处理 -->
<div v-on:click.capture="doThis">...</div>

<!-- 只有在 event.target 是元素自身时，才触发处理函数。 -->
<!-- 也就是说，event.target 是子元素时，不触发处理函数 -->
<div v-on:click.self="doThat">...</div>
<!-- 滚动事件的默认行为（滚动）将立即发生， -->
<!-- 而不是等待 `onScroll` 完成后才发生， -->
<!-- 以防在滚动事件的处理程序中含有 `event.preventDefault()` 调用 -->
<div v-on:scroll.passive="onScroll">...</div>
```



## 组件
组件(component)，是具有 name 名称的可复用 Vue 实例 核心目标是为了可重用性高，减少重复性开发，一般将组件代码按照template,style,script的拆分方式,放置到对应的.vue方式：当前示例中是 <button-counter>。我们可以使用 new Vue 创建出一个 Vue 根实例，然后将这个组件作为其中的一个自定义元素(custom element)。
### 核心要素
* 模板(template)----声明了数据和dom之间的映射关系
* 初始数据(data)----初始化数据，一般为私有状态
* 外部参数(props)----组件之间通过参数来进行数据共享和数据传递，参数默认为从上往下传递，可显示声明为双向绑定
* 方法(methods)----对数据的改动操作一般都在组件的方法内进行。通过v-on将事件和方法绑定
* 生命周期钩子函数(created,attached,destroyed...)


## 组件传值
```html
//父组件向子组件传值
<li
      is="todo-item"
      v-for="(todo, index) in todos"
      v-bind:key="todo.id"
      v-bind:title="todo.title"
      v-on:remove="todos.splice(index, 1)"
    ></li>
   // is在这里是必需的，它和调用<todo-item>一样的结果
  Vue.component('todo-item', {
  template: '\
    <li>\
      {{ title }}\
      <button v-on:click="$emit(\'remove\')">Remove</button>\
    </li>\
  ',
  props: ['title']
  //子组件与父组件通信,调用$emit方法,传递事件名称:
  <button v-on:click="$emit('enlarge-text')">
  放大文本
</button>
在event事件中传参
<button v-on:click="$emit('enlarge-text', 0.1)">
  放大文本
</button>
//可以通过$event访问这次发送事件的值
<blog-post
    ...
    v-on:enlarge-text="postFontSize += $event"
></blog-post>
//也可以通过方法中传参
<blog-post
  ...
  v-on:enlarge-text="onEnlargeText"
></blog-post>
//这个值将作为方法中的第一个参数
methods: {
  onEnlargeText: function (enlargeAmount) {
    this.postFontSize += enlargeAmount
  }
}
})
```

```html
<text-document v-bind:title.sync="doc.title"></text-document>
等价于
<text-document
  v-bind:title="doc.title"
  v-on:update:title="doc.title = $event"
></text-document>

//.sync 修饰符还可以用于 v-bind，使用一个对象一次性设置多个 prop：
<text-document v-bind.sync="doc"></text-document>
```
**组件传参的方式**

* 在父元素中通过v-bind:在子组件中用props接收,并应用到模板中.
可以用v-bind将动态props绑定到父组件的数据，每当父组件的数据变化时，该变化会传导给子组件
修饰符绑定
.sync:双向绑定
.once:当次绑定(默认),单次绑定在建立之后不会同步之后的变化。
prop验证要求
prop转换函数
propsData:在组件初始化后覆盖props中的属性
* 组件通信
组件通信手段主要通过事件监听
子组件:  v-on:click="方法名",当触发点击事件时，执行this.$emit(事件名，参数);
父组件:v-on:事件名=方法名,调用父组件的参数。(vue2通信方式)
* slot :内容分发 (与ng-trsclude类似，但是比ng-trsclude的功能更强大)
单个slot 
具名slot
```
<div>
  <slot name='firstName'></slot>
  <slot></slot>
  <slot name='two'><slot>
</div>
```
## 动态组件 
主要是利用component标签的is属性,进行组件的切换。从外层选择变量值，is属性绑定该变量值，控制展示的组件。



**组件注册**两种方式：全局注册和局部注册

## 进入、离开和列表的过渡
### 单元素/组件的过渡
  Vue提供了transition外层包裹容器组件，可以给v-if,v-show,动态组件,组件根节点添加进入和离开的过渡.

## 组件注册 
## 局部注册方式

mixin是分发Vue组件的可复用功能的一种非常灵活方式。每个mixin对象可以包含全部组件选项
定义一个minxin对象，
**选项合并**

* 当minxin对象和组件自身的选项对象,在二者选项名称相同时，Vue会选取合适的“合并”策略。
* 具有相同名称的钩子函数，将合并到一个数组中，最终他们会被依次调用。

全局minxin(global minxin)
* 一旦在全局中使用了 mixin，就会影响到之后创建的每个实例。

## 自定义指令
看一个在输入元素获取焦点的示例
```
// 注册一个名为 `v-focus` 的全局自定义指令
Vue.directive('focus', {
  // 当绑定的元素插入到 DOM 时调用此函数……
  inserted: function (el) {
    // 元素调用 focus 获取焦点
    el.focus()
  }
})
也可注册局部自定义指令
directives: {
  focus: {
    // 指令定义对象
    inserted: function (el) {
      el.focus()
    }
  }
}
//然后在模板中，你可以在任何元素上使用新增的 v-focus 属性
<input v-focus>
```
**指令的钩子函数**
* bind：在指令第一次绑定到元素时调用，只会调用一次。可以在此钩子函数中，执行一次性的初始化设置。
* inserted：在已绑定的元素插入到父节点时调用（只能保证父节点存在，不一定存在于 document 中）。
* update：在包含指令的组件的 VNode 更新后调用，但可能之前其子组件已更新。指令的值可能更新或者还没更新，然而可以通过比较绑定的当前值和旧值，来跳过不必要的更新（参考下面的钩子函数）。
* componentUpdated：在包含指令的组件的 VNode 更新后调用，并且其子组件的 VNode 已更新。
* unbind：在指令从元素上解除绑定时调用，只会调用一次。
指令钩子函数可传入以下参数：
* el:指令绑定的元素
* binding：一个对象，包含以下属性：name：指令的名称，不包括 v- 前缀。value：向指令传入的值。例如，在 v-my-directive="1 + 1" 中，传入的值是 2。oldValue：之前的值，只在 update 和 componentUpdated 钩子函数中可用。无论值是否发生变化，都可以使用。expression：指令绑定的表达式(expression)，以字符串格式。例如，在 v-my-directive="1 + 1" 中，表达式是 "1 + 1"。arg：向指令传入的参数，如果有的话。例如，在 v-my-directive:foo 中，参数是 "foo"。modifiers：一个对象，包含修饰符，如果有的话。例如，在 v-my-directive.foo.bar 中，修饰符是 { foo: true, bar: true }。
* vnode：由 Vue 编译器(Vue’s compiler)生成的虚拟 Node 节点(virtual node)。
* oldVnode：之前的虚拟 Node 节点(virtual node)，只在 update 和 componentUpdated 钩子函数中可用。


render函数&jsx

render函数可以作为模板的替代增强，比较接近于底层实现。
```
    Vue.component('anchored-heading', {
     render: function (createElement) {
         return createElement(
      'h' + this.level,   // 标签名称
      this.$slots.default // 由子节点构成的数组
    )
  },
    props: {
        level: {
        type: Number,
        required: true
        }
    }
})
//相当于创建一个模板
```
如上代码所示，如果大量用这种写法来创建模板的话，绝对是一个灾难，还好有一个Bable plugin插件，它可以让我们回到于更接近模板的语法上。
```
import AnchoredHeading from './AnchoredHeading.vue'

new Vue({
  el: '#demo',
  render: function (h) {
    return (
      <AnchoredHeading level={1}>
        <span>Hello</span> world!
      </AnchoredHeading>
    )
  }
})
```
## 函数式组件
```
Vue.component('my-component', {
  functional: true,
  // Props 是可选项
  props: {
    // ...
  },
  // 为了弥补缺少的实例
  // 我们提供了第二个参数 context 作为上下文
  render: function (createElement, context) {
    // ...
  }
})
```

模板的替代增强.

##  vue创建实例生命周期

beforeCreate create beforeMount mount beforeUpdate update beforeDestroy destroy


## 谷歌插件助手下载地址   http://www.ggfwzs.com/

## vue数据挂载
method one 
```
var app=new vue({
el:"#app",
data(){}
`````
})
```
method two
```
var app=new vue({
data(){}
})
app.$mount("#app")
```
利用$mount挂载的方法有一个很大的好处，就是将实例化的内容和他对HTML的关联分开，可以更直观的展现。
```

## 问题集

[链接](https://zhuanlan.zhihu.com/p/92407628)

1. vue的优点
2. vue父组件向子组件传递数据
3. 子组件向父组件传递事件
4. v-show和v-if的共同点和不同点
5. 如何让css只在当前组件中起作用
6. <keep-alive></keep-alive>的作用是什么
7. 如何获取dom节点
8. vue-loader的作用是什么，使用它的用途有哪些
9. 为什么要使用key
10. 分别简述computed和watch的作用
11. v-on监听多个方法

<input type="text" v-on="{ input:onInput,focus:onFocus,blur:onBlur, }">

12. vue组件

组建中的data写成一个函数，数据以函数返回值的形式定义，这样每次复用组件的时候，都会返回一份新的data，相当于每个组件实例都有自己私有的数据空间，它们只负责各自维护的数据，不会造成混乱。而单纯的写成对象形式，就是所有的组件实例共用了一个data，这样改一个全都改

13. 渐进式框架的理解

主张最少；可以根据不同的需求选择不同的层级；

14. vue中双向数据绑定是如何实现
15. 单应用和多应用的区别
16. v-if和v-for的区别
17. assets和static的区别
18. vue常用修饰符
19. vue 两个核心点
20. vue和jquery的区别
21. delete和Vue.delete删除数组的区别
22. SPA首屏加载慢如何解决
23. vue-router和locatioin.href的区别
24. vue slot
25. Vue router-link在电脑上有用，在安卓上没反应
26. vue2注册在router-link上事件无效的解决办法
27. Routerlink在ie和火狐路由不跳转问题
28. axios的特点
29. 