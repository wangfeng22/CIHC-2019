# CIHC-2019
`第一届全国信息隐藏大赛（The 1st
Chinese Information Hiding Competition）`

## 参赛项目

- [x] **作品**: `图像隐写检测`

- [x] **要求**:

  - 时间：在规定时间内(2019年6月15日 — 2019年10月1日)在网站上的[【比赛提交】栏目](http://www.cihw.org.cn/ )提交结果.

  - 评分：竞赛结果以 Accuracy 为得分按照从高到低进行排名判定。得分相同的情况下，参考F1-score.

- [x] 备注：
  
```
1. 提交的结果文件不符合格式要求视同为无效，超过规定时间提交的结果无效.
  
2. 若提交的文件无法解码或者提交最终结果格式不对，将导致没有成绩.
  
3. 比赛过程中，会不定期随机抽检 50%测试样本计算得分，并公布临时排名，临时排名[公布地址](http://www.cihw.org.cn/index.php/9/)。最终排名以完整测试集的检测得分为依据.
```
## 图像隐写检测数据集 
- [x] [```download dataset```](https://drive.google.com/open?id=144ImZ28zmvN_dZbbeJTyLjz8u8nGklSY)

```
 下载路径：【https://drive.google.com/open?id=144ImZ28zmvN_dZbbeJTyLjz8u8nGklSY】
 测试图像数量：1 万张
 测试图像来源：源自不同手机型号拍摄的原始未经处理的照片；
 测试图像尺寸：原始照片按最短边裁剪成正方形，然后统一缩放成 1024*1024 大小；
 测试图像品质因子：筛选出品质因子分布在 90-95 之间的图像；
 测试隐写算法：以 0.5 的概率选择数据集中的图像进行嵌入，嵌入算法选择三种不同的隐写算法以不同的嵌入率进行随机嵌入，三种隐写算法及相应的论文如下；
```
- [x] `相关论文`

|  隐写算法   |    相关论文                |
| :--------- | :------------------------- |
| J_unward   | V. Holub, J. Fridrich, T. Denemark, Universal Distortion Function for Steganography in an Arbitrary Domain, EURASIP Journal on Information Security |
| nsF5       | J. Fridrich, T. Pevný, and J. Kodovský, Statistically undetectable JPEG steganography: Dead ends, challenges, and opportunities. |
| UERD       | Using Statistical Image Model for JPEG Steganography: Uniform Embedding Revisited|

- [x] `辅助训练集和验证集：`

> 为了便于参赛队伍训练和调试模型，我们提供一个辅助训练集和验证集。该辅助训练集包含 10 万张来自网站[Unsplash](https://unsplash.com)的原始图像。经过和测试集图像同样的裁剪、缩放操作变成 1024*1024 大小，以和测试集同样的隐写策略进行随机比特流嵌入，最终获得 10 万对 cover-stego 图像（路径：./Image/train）。

> **注意：允许各参赛队使用额外数据对参赛模型进行训练和调试。**考虑到训练集和测试集图像来源不一致，因此我们从测试集中随机抽取 1809 张图像构成验证集（路径：./Image/valid），并提供验证集标签（路径：./Image/valid_labels.txt）。参赛队伍可以根据验证集测试结果调试模型。
