namespace winbattery1 {
    using System;
    using System.ComponentModel;
    using System.Management;
    using System.Collections;
    using System.Globalization;
    
    
    // 関数 ShouldSerialize<PropertyName> は、特定のプロパティをシリアル化する必要があるかどうかを調べるために VS プロパティ ブラウザで使用される関数です。これらの関数はすべての ValueType プロパティに追加されます ( NULL に設定できない型のプロパティ、Int32, BOOLなど)。これらの関数は Is<PropertyName>Null 関数を使用します。これらの関数はまた、プロパティの NULL 値を調べるプロパティのための TypeConverter 実装でも使用され、Visual studio でドラッグ アンド ドロップをする場合は、プロパティ ブラウザに空の値が表示されるようにします。
    // Functions Is<PropertyName>Null() は、プロパティが NULL かどうかを調べるために使用されます。
    // 関数 Reset<PropertyName> は Null 許容を使用できる読み込み/書き込みプロパティに追加されます。これらの関数は、プロパティを NULL に設定するためにプロパティ ブラウザの VS デザイナによって使用されます。
    // プロパティ用にクラスに追加されたすべてのプロパティは、Visual Studio デザイナ内での動作を定義するように、また使用する TypeConverter を定義するように設定されています。
    // 日付と時間の間隔変換機能 ToDateTime, ToDmtfDateTime, ToTimeSpan および ToDmtfTimeInterval は、DMTF 日付と時間間隔を System.DateTime / System.TimeSpan に相互間で変換するのにクラスに追加されました。
    // WMI クラス用に生成された事前バインディング クラスです。Win32_Battery
    public class Battery : System.ComponentModel.Component {
        
        // クラスが存在する場所にWMI 名前空間を保持するプライベート プロパティです。
        private static string CreatedWmiNamespace = "root\\CimV2";
        
        // このクラスを作成した WMI クラスの名前を保持するプライベート プロパティです。
        private static string CreatedClassName = "Win32_Battery";
        
        // さまざまなメソッドで使用される ManagementScope を保持するプライベート メンバ変数です。
        private static System.Management.ManagementScope statMgmtScope = null;
        
        private ManagementSystemProperties PrivateSystemProperties;
        
        // 基になる LateBound WMI オブジェクトです。
        private System.Management.ManagementObject PrivateLateBoundObject;
        
        // クラスの '自動コミット' 動作を保存するメンバ変数です。
        private bool AutoCommitProp;
        
        // インスタンスを表す埋め込みプロパティを保持するプライベート変数です。
        private System.Management.ManagementBaseObject embeddedObj;
        
        // 現在使用されている WMI オブジェクトです。
        private System.Management.ManagementBaseObject curObj;
        
        // インスタンスが埋め込みオブジェクトかどうかを示すフラグです。
        private bool isEmbedded;
        
        // 下記は WMI オブジェクトを使用してクラスのインスタンスを初期化するコンストラクタのオーバーロードです。
        public Battery() {
            this.InitializeObject(null, null, null);
        }
        
        public Battery(string keyDeviceID) {
            this.InitializeObject(null, new System.Management.ManagementPath(Battery.ConstructPath(keyDeviceID)), null);
        }
        
        public Battery(System.Management.ManagementScope mgmtScope, string keyDeviceID) {
            this.InitializeObject(((System.Management.ManagementScope)(mgmtScope)), new System.Management.ManagementPath(Battery.ConstructPath(keyDeviceID)), null);
        }
        
        public Battery(System.Management.ManagementPath path, System.Management.ObjectGetOptions getOptions) {
            this.InitializeObject(null, path, getOptions);
        }
        
        public Battery(System.Management.ManagementScope mgmtScope, System.Management.ManagementPath path) {
            this.InitializeObject(mgmtScope, path, null);
        }
        
        public Battery(System.Management.ManagementPath path) {
            this.InitializeObject(null, path, null);
        }
        
        public Battery(System.Management.ManagementScope mgmtScope, System.Management.ManagementPath path, System.Management.ObjectGetOptions getOptions) {
            this.InitializeObject(mgmtScope, path, getOptions);
        }
        
        public Battery(System.Management.ManagementObject theObject) {
            Initialize();
            if ((CheckIfProperClass(theObject) == true)) {
                PrivateLateBoundObject = theObject;
                PrivateSystemProperties = new ManagementSystemProperties(PrivateLateBoundObject);
                curObj = PrivateLateBoundObject;
            }
            else {
                throw new System.ArgumentException("クラス名が一致しません。");
            }
        }
        
        public Battery(System.Management.ManagementBaseObject theObject) {
            Initialize();
            if ((CheckIfProperClass(theObject) == true)) {
                embeddedObj = theObject;
                PrivateSystemProperties = new ManagementSystemProperties(theObject);
                curObj = embeddedObj;
                isEmbedded = true;
            }
            else {
                throw new System.ArgumentException("クラス名が一致しません。");
            }
        }
        
        // WMI クラスの名前空間を返すプロパティです。
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public string OriginatingNamespace {
            get {
                return "root\\CimV2";
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public string ManagementClassName {
            get {
                string strRet = CreatedClassName;
                if ((curObj != null)) {
                    if ((curObj.ClassPath != null)) {
                        strRet = ((string)(curObj["__CLASS"]));
                        if (((strRet == null) 
                                    || (strRet == string.Empty))) {
                            strRet = CreatedClassName;
                        }
                    }
                }
                return strRet;
            }
        }
        
        // WMI オブジェクトのシステム プロパティを取得するための埋め込みオブジェクトをポイントするプロパティです。
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public ManagementSystemProperties SystemProperties {
            get {
                return PrivateSystemProperties;
            }
        }
        
        // 基になる LateBound WMI オブジェクトを返すプロパティです。
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public System.Management.ManagementBaseObject LateBoundObject {
            get {
                return curObj;
            }
        }
        
        // オブジェクトの ManagementScope です。
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public System.Management.ManagementScope Scope {
            get {
                if ((isEmbedded == false)) {
                    return PrivateLateBoundObject.Scope;
                }
                else {
                    return null;
                }
            }
            set {
                if ((isEmbedded == false)) {
                    PrivateLateBoundObject.Scope = value;
                }
            }
        }
        
        // WMI オブジェクトのコミット動作を表示するプロパティです。 これが true の場合、プロパティが変更するたびに WMI オブジェクトは自動的に保存されます (すなわち、プロパティを変更した後で Put() が呼び出されます)。
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool AutoCommit {
            get {
                return AutoCommitProp;
            }
            set {
                AutoCommitProp = value;
            }
        }
        
        // 基になる WMI オブジェクトの ManagementPath です。
        [Browsable(true)]
        public System.Management.ManagementPath Path {
            get {
                if ((isEmbedded == false)) {
                    return PrivateLateBoundObject.Path;
                }
                else {
                    return null;
                }
            }
            set {
                if ((isEmbedded == false)) {
                    if ((CheckIfProperClass(null, value, null) != true)) {
                        throw new System.ArgumentException("クラス名が一致しません。");
                    }
                    PrivateLateBoundObject.Path = value;
                }
            }
        }
        
        // さまざまなメソッドで使用されるプライベート スタティック スコープ プロパティです。
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public static System.Management.ManagementScope StaticScope {
            get {
                return statMgmtScope;
            }
            set {
                statMgmtScope = value;
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsAvailabilityNull {
            get {
                if ((curObj["Availability"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description(@"デバイスの利用可能性と状態です。たとえば、Availability プロパティは、デバイスが実行中で通常の電力 (値 = 3) であるか、または警告中 (4)、テスト中 (5)、低下 (10)、または省電力状態 (値 = 13-15 および 17) であることを示します。省電力状態に関しては次のとおりに定義されます: 値 13 (""省電力 - 不明"") は、デバイスが省電力モードで認識されているが、このモードでの正確な状態は不明であることを示します。値 14 (""省電力 - 低電力モード"") は、デバイスは省電力モードで機能しているが、低下パフォーマンスであることを示します。値 15 (""省電力 - スタンバイ"") は、デバイスは機能していないが、すぐに通常の電力になることを示します。値 17 (""省電力 - 警告中"") は、デバイスは省電力モードだが、警告状態であることを示します。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public AvailabilityValues Availability {
            get {
                if ((curObj["Availability"] == null)) {
                    return ((AvailabilityValues)(System.Convert.ToInt32(0)));
                }
                return ((AvailabilityValues)(System.Convert.ToInt32(curObj["Availability"])));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsBatteryRechargeTimeNull {
            get {
                if ((curObj["BatteryRechargeTime"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("BatteryRechargeTime プロパティは、バッテリを完全に帯電するのに必要な時間を示します。\nBatteryRechargeTime プロパティは使用" +
            "されていません。置き換える値はなく、このプロパティは現在古い形式であると考えられます。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public uint BatteryRechargeTime {
            get {
                if ((curObj["BatteryRechargeTime"] == null)) {
                    return System.Convert.ToUInt32(0);
                }
                return ((uint)(curObj["BatteryRechargeTime"]));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsBatteryStatusNull {
            get {
                if ((curObj["BatteryStatus"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("バッテリの充電状態を示します。\"充電完了\" (値 = 3) or \"一部充電\" (11) が指定されます。値 10 は、DMI ではバッテリがインストールされてい" +
            "ないことを表すので CIM スキーマでは有効ではありません。この場合、このオブジェクトはインスタンス化しないでください。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public BatteryStatusValues BatteryStatus {
            get {
                if ((curObj["BatteryStatus"] == null)) {
                    return ((BatteryStatusValues)(System.Convert.ToInt32(0)));
                }
                return ((BatteryStatusValues)(System.Convert.ToInt32(curObj["BatteryStatus"])));
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("Caption プロパティは、オブジェクトについての簡単な説明 (1 行分の文字列) です。")]
        public string Caption {
            get {
                return ((string)(curObj["Caption"]));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsChemistryNull {
            get {
                if ((curObj["Chemistry"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("バッテリの特質を示す列挙です。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public ChemistryValues Chemistry {
            get {
                if ((curObj["Chemistry"] == null)) {
                    return ((ChemistryValues)(System.Convert.ToInt32(0)));
                }
                return ((ChemistryValues)(System.Convert.ToInt32(curObj["Chemistry"])));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsConfigManagerErrorCodeNull {
            get {
                if ((curObj["ConfigManagerErrorCode"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description(@"Win32 構成マネージャのエラー コードを示します。次の値が返されます: 
0	このデバイスは正常に動作しています。
1	このデバイスは正常に動作しています。
2	このデバイスのドライバを読み込めません。
3	このデバイスのドライバは壊れているか、あるいはメモリまたはほかのリソースが不足している状態でシステムが実行されている可能性があります。
4	このデバイスは正しく動作していません。ドライバの 1 つまたはレジストリが壊れている可能性があります。
5	このデバイスのドライバは、Windows で管理できないリソースが必要です。
6	このデバイスのブート構成がほかのデバイスと競合しています。
7	フィルタを操作できません。
8	デバイスのドライバ ローダーが不足しています。
9	このデバイスを制御するファームウェアがリソースを正しく報告していないため、このデバイスは正しく動作していません。
10	このデバイスを開始できません。
11	このデバイスを開けませんでした。
12	このデバイスが使用できる空きリソースが不足しています。
13	このデバイスのリソースを確認できません。
14	コンピュータを再起動するまでこのデバイスは正しく動作しません。
15	このデバイスは、再列挙に問題が発生している可能性があるため正常に作動していません。
16	このデバイスが使うリソースで、Windows が識別できないものがあります。
17	このデバイスは不明なリソースの種類を求めています。
18	このデバイスのドライバを再インストールする必要があります。
19	レジストリが壊れている可能性があります。
20	VxD ローダーの使用に失敗しました。
21	システム障害: このデバイスのドライバを変更してみてください。うまくいかない場合はハードウェアのマニュアルを参照してください。このデバイスを削除しています。
22	このデバイスは利用できません。
23	システム障害: このデバイスのドライバを変更してみてください。うまくいかない場合はハードウェアのマニュアルを参照してください。
24	このデバイスが存在しないか、正しく動作していないか、またはインストールされていないドライバがあります。
25	このデバイスのセットアップをまだ処理しています。
26	このデバイスのセットアップをまだ処理しています。
27	このデバイスに有効なログ構成がありません。
28	このデバイスのドライバがインストールされていません。
29	このデバイスは、デバイスのファームウェアによって必要なリソースを与えられていないため無効です。
30	このデバイスは、別のデバイスが使用している割り込み要求 (IRQ) リソースを使っています。
31	このデバイスに必要なドライバを読み込めないため、このデバイスは正しく動作していません。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public ConfigManagerErrorCodeValues ConfigManagerErrorCode {
            get {
                if ((curObj["ConfigManagerErrorCode"] == null)) {
                    return ((ConfigManagerErrorCodeValues)(System.Convert.ToInt32(32)));
                }
                return ((ConfigManagerErrorCodeValues)(System.Convert.ToInt32(curObj["ConfigManagerErrorCode"])));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsConfigManagerUserConfigNull {
            get {
                if ((curObj["ConfigManagerUserConfig"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("デバイスがユーザー定義の構成を使用しているかどうかを示します。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public bool ConfigManagerUserConfig {
            get {
                if ((curObj["ConfigManagerUserConfig"] == null)) {
                    return System.Convert.ToBoolean(0);
                }
                return ((bool)(curObj["ConfigManagerUserConfig"]));
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("CreationClassName は、インスタンスの作成で使用されるクラス名、またはサブクラス名を示します。このクラスのほかのキーのプロパティと一緒に使用すると" +
            "、このクラスおよびそのサブクラスのインスタンスすべてがこのプロパティによって一意に識別されます。")]
        public string CreationClassName {
            get {
                return ((string)(curObj["CreationClassName"]));
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("Description プロパティでオブジェクトの説明が提供されます。 ")]
        public string Description {
            get {
                return ((string)(curObj["Description"]));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsDesignCapacityNull {
            get {
                if ((curObj["DesignCapacity"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("ミリワット時単位のバッテリのデザイン容量です。このプロパティがサポートされない場合、0 を入力してください。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public uint DesignCapacity {
            get {
                if ((curObj["DesignCapacity"] == null)) {
                    return System.Convert.ToUInt32(0);
                }
                return ((uint)(curObj["DesignCapacity"]));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsDesignVoltageNull {
            get {
                if ((curObj["DesignVoltage"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("ミリボルト単位のバッテリのデザイン電圧です。この属性がサポートされない場合は 0 を入力してください。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public ulong DesignVoltage {
            get {
                if ((curObj["DesignVoltage"] == null)) {
                    return System.Convert.ToUInt64(0);
                }
                return ((ulong)(curObj["DesignVoltage"]));
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("DeviceID プロパティには、バッテリを識別する文字列が含まれています。\n例: 内部バッテリ")]
        public string DeviceID {
            get {
                return ((string)(curObj["DeviceID"]));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsErrorClearedNull {
            get {
                if ((curObj["ErrorCleared"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("ErrorCleared は LastErrorCode プロパティで報告されたエラーが現在は消去されていることを示すブール値のプロパティです。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public bool ErrorCleared {
            get {
                if ((curObj["ErrorCleared"] == null)) {
                    return System.Convert.ToBoolean(0);
                }
                return ((bool)(curObj["ErrorCleared"]));
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("ErrorDescription は LastErrorCode プロパティで記録されたエラーに関する情報および実行される可能性がある修正の情報を提供する自由形式" +
            "の文字列です。")]
        public string ErrorDescription {
            get {
                return ((string)(curObj["ErrorDescription"]));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsEstimatedChargeRemainingNull {
            get {
                if ((curObj["EstimatedChargeRemaining"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("完全に充電するための残りのパーセントを予想します。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public ushort EstimatedChargeRemaining {
            get {
                if ((curObj["EstimatedChargeRemaining"] == null)) {
                    return System.Convert.ToUInt16(0);
                }
                return ((ushort)(curObj["EstimatedChargeRemaining"]));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsEstimatedRunTimeNull {
            get {
                if ((curObj["EstimatedRunTime"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("EstimatedRunTime は、ユーティリティ電力がオフになっているか、電力がない状態になっている、またはラップトップが電源につながっていない場合、現在のロ" +
            "ード状態でのバッテリの消耗予想時間 (分) です。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public uint EstimatedRunTime {
            get {
                if ((curObj["EstimatedRunTime"] == null)) {
                    return System.Convert.ToUInt32(0);
                }
                return ((uint)(curObj["EstimatedRunTime"]));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsExpectedBatteryLifeNull {
            get {
                if ((curObj["ExpectedBatteryLife"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("ExpectedBatteryLife プロパティにより、バッテリを完全に充電した後に、完全に放電させるのにかかる時間を示します。 \nExpectedBatter" +
            "yLife プロパティは使用されていません。置き換える値はなく、このプロパティは現在古い形式であると考えられます。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public uint ExpectedBatteryLife {
            get {
                if ((curObj["ExpectedBatteryLife"] == null)) {
                    return System.Convert.ToUInt32(0);
                }
                return ((uint)(curObj["ExpectedBatteryLife"]));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsExpectedLifeNull {
            get {
                if ((curObj["ExpectedLife"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("バッテリが完全に充電されているとして、バッテリの寿命の予想時間を分で示します。このプロパティは、EstimatedRunTime プロパティに示される現在のバッテ" +
            "リの残り寿命ではなく、バッテリの予想される寿命を表します。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public uint ExpectedLife {
            get {
                if ((curObj["ExpectedLife"] == null)) {
                    return System.Convert.ToUInt32(0);
                }
                return ((uint)(curObj["ExpectedLife"]));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsFullChargeCapacityNull {
            get {
                if ((curObj["FullChargeCapacity"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("バッテリの完全充電の容量 (ミリワット時単位) この値と DesignCapacity プロパティを比較することで、バッテリの交換が必要となるときが決定されます。" +
            "バッテリの寿命は、通常 FullChargeCapacity プロパティが DesignCapacity プロパティの 80% より下になるときに切れます。この" +
            "プロパティがサポートされない場合、0 を入力してください。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public uint FullChargeCapacity {
            get {
                if ((curObj["FullChargeCapacity"] == null)) {
                    return System.Convert.ToUInt32(0);
                }
                return ((uint)(curObj["FullChargeCapacity"]));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsInstallDateNull {
            get {
                if ((curObj["InstallDate"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("InstallDate プロパティは、オブジェクトがインストールされた日時を示す値です。値が不足しているとオブジェクトがインストールされていないことを表示しません" +
            "。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public System.DateTime InstallDate {
            get {
                if ((curObj["InstallDate"] != null)) {
                    return ToDateTime(((string)(curObj["InstallDate"])));
                }
                else {
                    return System.DateTime.MinValue;
                }
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsLastErrorCodeNull {
            get {
                if ((curObj["LastErrorCode"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("論理デバイスで報告されたエラー コードが LastErrorCode によってキャプチャされます。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public uint LastErrorCode {
            get {
                if ((curObj["LastErrorCode"] == null)) {
                    return System.Convert.ToUInt32(0);
                }
                return ((uint)(curObj["LastErrorCode"]));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsMaxRechargeTimeNull {
            get {
                if ((curObj["MaxRechargeTime"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("MaxRechargeTime はバッテリを完全に充電するための最長時間 (分) を示します。このプロパティは、TimeToFullCharge プロパティに示さ" +
            "れる現在の残り充電時間ではなく、完全に消耗したバッテリを再充電する時間を表します。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public uint MaxRechargeTime {
            get {
                if ((curObj["MaxRechargeTime"] == null)) {
                    return System.Convert.ToUInt32(0);
                }
                return ((uint)(curObj["MaxRechargeTime"]));
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("Name プロパティで、オブジェクトを認識するラベルを定義します。サブクラスの場合、Name プロパティは上書きされて Key プロパティとなります。")]
        public string Name {
            get {
                return ((string)(curObj["Name"]));
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("論理デバイスの Win32 プラグ アンド プレイ デバイス ID を示します。例: *PNP030b")]
        public string PNPDeviceID {
            get {
                return ((string)(curObj["PNPDeviceID"]));
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description(@"論理デバイスの特定の電源関連機能を示します。0=""不明""、1=""サポートされていません""、および 2=""無効""に関する値の説明はありません。3=""有効"" は、電源管理機能は現在有効であるが、正確な機能設定は不明か、または情報が利用不可であることを示します。""自動省電力モード"" (4) は、デバイスが使用方法に、またはほかの条件に基づく電力状態を変更できることを説明しています。""電源の状態設定可能"" (5) は、SetPowerState 方法がサポートされていることを示します。""電源サイクル サポート"" (6) は、5 (""電源サイクル"") に設定された PowerState 入力変数で SetPowerState 方法を呼び出すことができることを示します。""時刻指定電源オン サポート"" (7) は、5 (""電源サイクル"") に設定された PowerState 入力変数、および電源オンを特定の日付と時刻に、または間隔に設定された時刻パラメータで SetPowerState 方法を呼び出すことができることを示します。")]
        public PowerManagementCapabilitiesValues[] PowerManagementCapabilities {
            get {
                System.Array arrEnumVals = ((System.Array)(curObj["PowerManagementCapabilities"]));
                PowerManagementCapabilitiesValues[] enumToRet = new PowerManagementCapabilitiesValues[arrEnumVals.Length];
                int counter = 0;
                for (counter = 0; (counter < arrEnumVals.Length); counter = (counter + 1)) {
                    enumToRet[counter] = ((PowerManagementCapabilitiesValues)(System.Convert.ToInt32(arrEnumVals.GetValue(counter))));
                }
                return enumToRet;
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsPowerManagementSupportedNull {
            get {
                if ((curObj["PowerManagementSupported"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("デバイスを電源管理できることを示すブール値です - 例、省電力状態にする。電源管理機能が現在有効であること、または有効な場合にサポートされる機能、はこのブール値で" +
            "は表示されません。この情報の PowerManagementCapabilities 配列への参照です。このブール値が false の場合は、文字列 \"サポート" +
            "されていません\" の整数値 1 だけが PowerManagementCapabilities 配列のエントリです。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public bool PowerManagementSupported {
            get {
                if ((curObj["PowerManagementSupported"] == null)) {
                    return System.Convert.ToBoolean(0);
                }
                return ((bool)(curObj["PowerManagementSupported"]));
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("このバッテリにサポートされる Smart Battery Data Specification バージョン番号です。バッテリによりこの機能がサポートされない場合、" +
            "値は空白のままである必要があります。")]
        public string SmartBatteryVersion {
            get {
                return ((string)(curObj["SmartBatteryVersion"]));
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description(@"Status プロパティはオブジェクトの現在の状態を示す文字列です。操作可能な状態および操作不可能な状態が定義されます。操作可能な状態は、""OK""、""低下""および""障害が発生する可能性あり""です。""障害が発生する可能性あり""は、要素は適切に機能するけれども近いうちに障害が発生する可能性があることを示します。例:  SMART-enabled ハード ディスク。 操作不可能な状態も指定できます。これは、""エラー""、""開始中""、""停止動作中""および""サービス""です。最後の""サービス""は、ディスクがミラーされている間、ユーザーのアクセス許可の一覧を再度読み込む間、またはほかの管理用作業が行われている間に適用することができます。この作業がすべてオンラインで行われるとは限りませんが、[管理要素] は""OK""でもほかの状態でもありません。")]
        public string Status {
            get {
                return ((string)(curObj["Status"]));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsStatusInfoNull {
            get {
                if ((curObj["StatusInfo"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("StatusInfo は、論理デバイスが有効 (値 = 3)、無効 (値 = 4) またはその他 (1) または不明 (2) 状態であるかどうかを示す文字列です。" +
            "このプロパティが論理デバイスを適用しない場合の値は、5 (\"該当なし\") が使用されます。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public StatusInfoValues StatusInfo {
            get {
                if ((curObj["StatusInfo"] == null)) {
                    return ((StatusInfoValues)(System.Convert.ToInt32(0)));
                }
                return ((StatusInfoValues)(System.Convert.ToInt32(curObj["StatusInfo"])));
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("スコーピング システムの CreationClassName です。 ")]
        public string SystemCreationClassName {
            get {
                return ((string)(curObj["SystemCreationClassName"]));
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("スコーピング システムの名前です。")]
        public string SystemName {
            get {
                return ((string)(curObj["SystemName"]));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsTimeOnBatteryNull {
            get {
                if ((curObj["TimeOnBattery"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("TimeOnBattery は、コンピュータ システムの UPS がバッテリ電源に最後に切り替わったときからの経過時間 (秒)か、システムまたは UPS が最後に" +
            "再起動したときの時間を示します。バッテリが \'オン ライン\' の場合は 0 が返ります。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public uint TimeOnBattery {
            get {
                if ((curObj["TimeOnBattery"] == null)) {
                    return System.Convert.ToUInt32(0);
                }
                return ((uint)(curObj["TimeOnBattery"]));
            }
        }
        
        [Browsable(false)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        public bool IsTimeToFullChargeNull {
            get {
                if ((curObj["TimeToFullCharge"] == null)) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        
        [Browsable(true)]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
        [Description("現在の充電レートと使用で、バッテリを完全に充電するまでの残り時間 (分) です。")]
        [TypeConverter(typeof(WMIValueTypeConverter))]
        public uint TimeToFullCharge {
            get {
                if ((curObj["TimeToFullCharge"] == null)) {
                    return System.Convert.ToUInt32(0);
                }
                return ((uint)(curObj["TimeToFullCharge"]));
            }
        }
        
        private bool CheckIfProperClass(System.Management.ManagementScope mgmtScope, System.Management.ManagementPath path, System.Management.ObjectGetOptions OptionsParam) {
            if (((path != null) 
                        && (string.Compare(path.ClassName, this.ManagementClassName, true, System.Globalization.CultureInfo.InvariantCulture) == 0))) {
                return true;
            }
            else {
                return CheckIfProperClass(new System.Management.ManagementObject(mgmtScope, path, OptionsParam));
            }
        }
        
        private bool CheckIfProperClass(System.Management.ManagementBaseObject theObj) {
            if (((theObj != null) 
                        && (string.Compare(((string)(theObj["__CLASS"])), this.ManagementClassName, true, System.Globalization.CultureInfo.InvariantCulture) == 0))) {
                return true;
            }
            else {
                System.Array parentClasses = ((System.Array)(theObj["__DERIVATION"]));
                if ((parentClasses != null)) {
                    int count = 0;
                    for (count = 0; (count < parentClasses.Length); count = (count + 1)) {
                        if ((string.Compare(((string)(parentClasses.GetValue(count))), this.ManagementClassName, true, System.Globalization.CultureInfo.InvariantCulture) == 0)) {
                            return true;
                        }
                    }
                }
            }
            return false;
        }
        
        private bool ShouldSerializeAvailability() {
            if ((this.IsAvailabilityNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeBatteryRechargeTime() {
            if ((this.IsBatteryRechargeTimeNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeBatteryStatus() {
            if ((this.IsBatteryStatusNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeChemistry() {
            if ((this.IsChemistryNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeConfigManagerErrorCode() {
            if ((this.IsConfigManagerErrorCodeNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeConfigManagerUserConfig() {
            if ((this.IsConfigManagerUserConfigNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeDesignCapacity() {
            if ((this.IsDesignCapacityNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeDesignVoltage() {
            if ((this.IsDesignVoltageNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeErrorCleared() {
            if ((this.IsErrorClearedNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeEstimatedChargeRemaining() {
            if ((this.IsEstimatedChargeRemainingNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeEstimatedRunTime() {
            if ((this.IsEstimatedRunTimeNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeExpectedBatteryLife() {
            if ((this.IsExpectedBatteryLifeNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeExpectedLife() {
            if ((this.IsExpectedLifeNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeFullChargeCapacity() {
            if ((this.IsFullChargeCapacityNull == false)) {
                return true;
            }
            return false;
        }
        
        // 指定された日付と時間を DMTF 形式から System.DateTime オブジェクトに変換します。
        static System.DateTime ToDateTime(string dmtfDate) {
            System.DateTime initializer = System.DateTime.MinValue;
            int year = initializer.Year;
            int month = initializer.Month;
            int day = initializer.Day;
            int hour = initializer.Hour;
            int minute = initializer.Minute;
            int second = initializer.Second;
            long ticks = 0;
            string dmtf = dmtfDate;
            System.DateTime datetime = System.DateTime.MinValue;
            string tempString = string.Empty;
            if ((dmtf == null)) {
                throw new System.ArgumentOutOfRangeException();
            }
            if ((dmtf.Length == 0)) {
                throw new System.ArgumentOutOfRangeException();
            }
            if ((dmtf.Length != 25)) {
                throw new System.ArgumentOutOfRangeException();
            }
            try {
                tempString = dmtf.Substring(0, 4);
                if (("****" != tempString)) {
                    year = int.Parse(tempString);
                }
                tempString = dmtf.Substring(4, 2);
                if (("**" != tempString)) {
                    month = int.Parse(tempString);
                }
                tempString = dmtf.Substring(6, 2);
                if (("**" != tempString)) {
                    day = int.Parse(tempString);
                }
                tempString = dmtf.Substring(8, 2);
                if (("**" != tempString)) {
                    hour = int.Parse(tempString);
                }
                tempString = dmtf.Substring(10, 2);
                if (("**" != tempString)) {
                    minute = int.Parse(tempString);
                }
                tempString = dmtf.Substring(12, 2);
                if (("**" != tempString)) {
                    second = int.Parse(tempString);
                }
                tempString = dmtf.Substring(15, 6);
                if (("******" != tempString)) {
                    ticks = (long.Parse(tempString) * ((long)((System.TimeSpan.TicksPerMillisecond / 1000))));
                }
                if (((((((((year < 0) 
                            || (month < 0)) 
                            || (day < 0)) 
                            || (hour < 0)) 
                            || (minute < 0)) 
                            || (minute < 0)) 
                            || (second < 0)) 
                            || (ticks < 0))) {
                    throw new System.ArgumentOutOfRangeException();
                }
            }
            catch (System.Exception e) {
                throw new System.ArgumentOutOfRangeException(null, e.Message);
            }
            datetime = new System.DateTime(year, month, day, hour, minute, second, 0);
            datetime = datetime.AddTicks(ticks);
            System.TimeSpan tickOffset = System.TimeZone.CurrentTimeZone.GetUtcOffset(datetime);
            int UTCOffset = 0;
            int OffsetToBeAdjusted = 0;
            long OffsetMins = ((long)((tickOffset.Ticks / System.TimeSpan.TicksPerMinute)));
            tempString = dmtf.Substring(22, 3);
            if ((tempString != "******")) {
                tempString = dmtf.Substring(21, 4);
                try {
                    UTCOffset = int.Parse(tempString);
                }
                catch (System.Exception e) {
                    throw new System.ArgumentOutOfRangeException(null, e.Message);
                }
                OffsetToBeAdjusted = ((int)((OffsetMins - UTCOffset)));
                datetime = datetime.AddMinutes(((double)(OffsetToBeAdjusted)));
            }
            return datetime;
        }
        
        // 指定された System.DateTime オブジェクトを DMTF 日付と時間の形式に変換します。
        static string ToDmtfDateTime(System.DateTime date) {
            string utcString = string.Empty;
            System.TimeSpan tickOffset = System.TimeZone.CurrentTimeZone.GetUtcOffset(date);
            long OffsetMins = ((long)((tickOffset.Ticks / System.TimeSpan.TicksPerMinute)));
            if ((System.Math.Abs(OffsetMins) > 999)) {
                date = date.ToUniversalTime();
                utcString = "+000";
            }
            else {
                if ((tickOffset.Ticks >= 0)) {
                    utcString = string.Concat("+", ((System.Int64 )((tickOffset.Ticks / System.TimeSpan.TicksPerMinute))).ToString().PadLeft(3, '0'));
                }
                else {
                    string strTemp = ((System.Int64 )(OffsetMins)).ToString();
                    utcString = string.Concat("-", strTemp.Substring(1, (strTemp.Length - 1)).PadLeft(3, '0'));
                }
            }
            string dmtfDateTime = ((System.Int32 )(date.Year)).ToString().PadLeft(4, '0');
            dmtfDateTime = string.Concat(dmtfDateTime, ((System.Int32 )(date.Month)).ToString().PadLeft(2, '0'));
            dmtfDateTime = string.Concat(dmtfDateTime, ((System.Int32 )(date.Day)).ToString().PadLeft(2, '0'));
            dmtfDateTime = string.Concat(dmtfDateTime, ((System.Int32 )(date.Hour)).ToString().PadLeft(2, '0'));
            dmtfDateTime = string.Concat(dmtfDateTime, ((System.Int32 )(date.Minute)).ToString().PadLeft(2, '0'));
            dmtfDateTime = string.Concat(dmtfDateTime, ((System.Int32 )(date.Second)).ToString().PadLeft(2, '0'));
            dmtfDateTime = string.Concat(dmtfDateTime, ".");
            System.DateTime dtTemp = new System.DateTime(date.Year, date.Month, date.Day, date.Hour, date.Minute, date.Second, 0);
            long microsec = ((long)((((date.Ticks - dtTemp.Ticks) 
                        * 1000) 
                        / System.TimeSpan.TicksPerMillisecond)));
            string strMicrosec = ((System.Int64 )(microsec)).ToString();
            if ((strMicrosec.Length > 6)) {
                strMicrosec = strMicrosec.Substring(0, 6);
            }
            dmtfDateTime = string.Concat(dmtfDateTime, strMicrosec.PadLeft(6, '0'));
            dmtfDateTime = string.Concat(dmtfDateTime, utcString);
            return dmtfDateTime;
        }
        
        private bool ShouldSerializeInstallDate() {
            if ((this.IsInstallDateNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeLastErrorCode() {
            if ((this.IsLastErrorCodeNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeMaxRechargeTime() {
            if ((this.IsMaxRechargeTimeNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializePowerManagementSupported() {
            if ((this.IsPowerManagementSupportedNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeStatusInfo() {
            if ((this.IsStatusInfoNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeTimeOnBattery() {
            if ((this.IsTimeOnBatteryNull == false)) {
                return true;
            }
            return false;
        }
        
        private bool ShouldSerializeTimeToFullCharge() {
            if ((this.IsTimeToFullChargeNull == false)) {
                return true;
            }
            return false;
        }
        
        [Browsable(true)]
        public void CommitObject() {
            if ((isEmbedded == false)) {
                PrivateLateBoundObject.Put();
            }
        }
        
        [Browsable(true)]
        public void CommitObject(System.Management.PutOptions putOptions) {
            if ((isEmbedded == false)) {
                PrivateLateBoundObject.Put(putOptions);
            }
        }
        
        private void Initialize() {
            AutoCommitProp = true;
            isEmbedded = false;
        }
        
        private static string ConstructPath(string keyDeviceID) {
            string strPath = "root\\CimV2:Win32_Battery";
            strPath = string.Concat(strPath, string.Concat(".DeviceID=", string.Concat("\"", string.Concat(keyDeviceID, "\""))));
            return strPath;
        }
        
        private void InitializeObject(System.Management.ManagementScope mgmtScope, System.Management.ManagementPath path, System.Management.ObjectGetOptions getOptions) {
            Initialize();
            if ((path != null)) {
                if ((CheckIfProperClass(mgmtScope, path, getOptions) != true)) {
                    throw new System.ArgumentException("クラス名が一致しません。");
                }
            }
            PrivateLateBoundObject = new System.Management.ManagementObject(mgmtScope, path, getOptions);
            PrivateSystemProperties = new ManagementSystemProperties(PrivateLateBoundObject);
            curObj = PrivateLateBoundObject;
        }
        
        // WMI クラスのインスタンスを列挙する GetInstances() ヘルプのオーバーロードです。
        public static BatteryCollection GetInstances() {
            return GetInstances(null, null, null);
        }
        
        public static BatteryCollection GetInstances(string condition) {
            return GetInstances(null, condition, null);
        }
        
        public static BatteryCollection GetInstances(System.String [] selectedProperties) {
            return GetInstances(null, null, selectedProperties);
        }
        
        public static BatteryCollection GetInstances(string condition, System.String [] selectedProperties) {
            return GetInstances(null, condition, selectedProperties);
        }
        
        public static BatteryCollection GetInstances(System.Management.ManagementScope mgmtScope, System.Management.EnumerationOptions enumOptions) {
            if ((mgmtScope == null)) {
                if ((statMgmtScope == null)) {
                    mgmtScope = new System.Management.ManagementScope();
                    mgmtScope.Path.NamespacePath = "root\\CimV2";
                }
                else {
                    mgmtScope = statMgmtScope;
                }
            }
            System.Management.ManagementPath pathObj = new System.Management.ManagementPath();
            pathObj.ClassName = "Win32_Battery";
            pathObj.NamespacePath = "root\\CimV2";
            System.Management.ManagementClass clsObject = new System.Management.ManagementClass(mgmtScope, pathObj, null);
            if ((enumOptions == null)) {
                enumOptions = new System.Management.EnumerationOptions();
                enumOptions.EnsureLocatable = true;
            }
            return new BatteryCollection(clsObject.GetInstances(enumOptions));
        }
        
        public static BatteryCollection GetInstances(System.Management.ManagementScope mgmtScope, string condition) {
            return GetInstances(mgmtScope, condition, null);
        }
        
        public static BatteryCollection GetInstances(System.Management.ManagementScope mgmtScope, System.String [] selectedProperties) {
            return GetInstances(mgmtScope, null, selectedProperties);
        }
        
        public static BatteryCollection GetInstances(System.Management.ManagementScope mgmtScope, string condition, System.String [] selectedProperties) {
            if ((mgmtScope == null)) {
                if ((statMgmtScope == null)) {
                    mgmtScope = new System.Management.ManagementScope();
                    mgmtScope.Path.NamespacePath = "root\\CimV2";
                }
                else {
                    mgmtScope = statMgmtScope;
                }
            }
            System.Management.ManagementObjectSearcher ObjectSearcher = new System.Management.ManagementObjectSearcher(mgmtScope, new SelectQuery("Win32_Battery", condition, selectedProperties));
            System.Management.EnumerationOptions enumOptions = new System.Management.EnumerationOptions();
            enumOptions.EnsureLocatable = true;
            ObjectSearcher.Options = enumOptions;
            return new BatteryCollection(ObjectSearcher.Get());
        }
        
        [Browsable(true)]
        public static Battery CreateInstance() {
            System.Management.ManagementScope mgmtScope = null;
            if ((statMgmtScope == null)) {
                mgmtScope = new System.Management.ManagementScope();
                mgmtScope.Path.NamespacePath = CreatedWmiNamespace;
            }
            else {
                mgmtScope = statMgmtScope;
            }
            System.Management.ManagementPath mgmtPath = new System.Management.ManagementPath(CreatedClassName);
            System.Management.ManagementClass tmpMgmtClass = new System.Management.ManagementClass(mgmtScope, mgmtPath, null);
            return new Battery(tmpMgmtClass.CreateInstance());
        }
        
        [Browsable(true)]
        public void Delete() {
            PrivateLateBoundObject.Delete();
        }
        
        public uint Reset() {
            if ((isEmbedded == false)) {
                System.Management.ManagementBaseObject inParams = null;
                System.Management.ManagementBaseObject outParams = PrivateLateBoundObject.InvokeMethod("Reset", inParams, null);
                return System.Convert.ToUInt32(outParams.Properties["ReturnValue"].Value);
            }
            else {
                return System.Convert.ToUInt32(0);
            }
        }
        
        public uint SetPowerState(ushort PowerState, System.DateTime Time) {
            if ((isEmbedded == false)) {
                System.Management.ManagementBaseObject inParams = null;
                inParams = PrivateLateBoundObject.GetMethodParameters("SetPowerState");
                inParams["PowerState"] = ((System.UInt16 )(PowerState));
                inParams["Time"] = ToDmtfDateTime(((System.DateTime)(Time)));
                System.Management.ManagementBaseObject outParams = PrivateLateBoundObject.InvokeMethod("SetPowerState", inParams, null);
                return System.Convert.ToUInt32(outParams.Properties["ReturnValue"].Value);
            }
            else {
                return System.Convert.ToUInt32(0);
            }
        }
        
        public enum AvailabilityValues {
            
            その他 = 1,
            
            不明 = 2,
            
            実行中_通常の電力 = 3,
            
            警告 = 4,
            
            テスト中 = 5,
            
            該当なし = 6,
            
            電源オフ = 7,
            
            オフライン = 8,
            
            時間外 = 9,
            
            低下 = 10,
            
            インストールされていません = 11,
            
            インストール_エラー = 12,
            
            省電力_不明 = 13,
            
            省電力_低電力モード = 14,
            
            省電力_スタンバイ = 15,
            
            電源サイクル = 16,
            
            省電力_警告中 = 17,
            
            一時停止 = 18,
            
            準備されていません = 19,
            
            構成されていません = 20,
            
            休止しています = 21,
            
            NULL_ENUM_VALUE = 0,
        }
        
        public enum BatteryStatusValues {
            
            その他 = 1,
            
            不明 = 2,
            
            充電完了 = 3,
            
            低 = 4,
            
            致命的 = 5,
            
            充電中 = 6,
            
            充電中_高 = 7,
            
            充電中_低 = 8,
            
            充電中_消耗 = 9,
            
            未定義 = 10,
            
            一部充電 = 11,
            
            NULL_ENUM_VALUE = 0,
        }
        
        public enum ChemistryValues {
            
            その他 = 1,
            
            不明 = 2,
            
            鉛酸 = 3,
            
            ニッケル_カドミウム = 4,
            
            ニッケル水素 = 5,
            
            リチウム_イオン = 6,
            
            亜鉛空気 = 7,
            
            リチウム_ポリマ = 8,
            
            NULL_ENUM_VALUE = 0,
        }
        
        public enum ConfigManagerErrorCodeValues {
            
            このデバイスは正常に作動しています_ = 0,
            
            このデバイスは正しく構成されていません_ = 1,
            
            このデバイスのドライバを読み込めません_ = 2,
            
            このデバイスのドライバは壊れているか_あるいはメモリまたはほかのリソースが不足している状態でシステムが実行されている可能性があります_ = 3,
            
            このデバイスは正常に作動していません_デバイスのドライバまたはレジストリが壊れている可能性があります_ = 4,
            
            このデバイスのドライバには_Windows_が管理できないリソースが必要です_ = 5,
            
            このデバイスのブート構成はほかのデバイスと競合します_ = 6,
            
            フィルタ処理できません_ = 7,
            
            デバイスのドライバ_ローダーが見つかりません_ = 8,
            
            このデバイスは_制御ファームウェアによってデバイスのリソースが正しくないと報告されているため_正常に作動しません_ = 9,
            
            このデバイスを開始できません_ = 10,
            
            このデバイスは失敗しました_ = 11,
            
            このデバイスが使用できる十分な空きリソースが見つかりません_ = 12,
            
            このデバイスのリソースを確認できません_ = 13,
            
            コンピュータを再起動するまでこのデバイスは正常に作動しません_ = 14,
            
            このデバイスは_再列挙に問題が発生している可能性があるため正常に作動していません_ = 15,
            
            このデバイスで使用される一部のリソースを認識できません_ = 16,
            
            このデバイスは不明なリソースの種類を要求しています_ = 17,
            
            このデバイスのドライバを再インストールしてください_ = 18,
            
            VxD_ローダーの使用に失敗しました_ = 19,
            
            レジストリが壊れている可能性があります_ = 20,
            
            システム_エラー_このデバイスのドライバを変更してください_作動しない場合は_ハードウェア_ドキュメントを参照してください_このデバイスは削除されます_ = 21,
            
            このデバイスは無効です_ = 22,
            
            システム_エラー_このデバイスのドライバを変更してください_作動しない場合は_ハードウェア_ドキュメントを参照してください_ = 23,
            
            このデバイスは存在しないか_正常に作動していないか_または一部のドライバがインストールされていません_ = 24,
            
            デバイスをセットアップしています_ = 25,
            
            デバイスをセットアップしています_0 = 26,
            
            このデバイスに有効なログ構成がありません_ = 27,
            
            このデバイスのドライバはインストールされていません_ = 28,
            
            このデバイスは_デバイスのファームウェアによって必要なリソースが与えられなかったため無効です_ = 29,
            
            このデバイスは_ほかのデバイスが使用している割り込み要求_IRQ_リソースを使用しています_ = 30,
            
            このデバイスは_このデバイスに必要なドライバを読み込めないため正常に作動していません_ = 31,
            
            NULL_ENUM_VALUE = 32,
        }
        
        public enum PowerManagementCapabilitiesValues {
            
            不明 = 0,
            
            サポートされていません = 1,
            
            無効 = 2,
            
            有効 = 3,
            
            自動省電力モード = 4,
            
            電源の状態設定可能 = 5,
            
            電源サイクル_サポート = 6,
            
            時刻指定電源オン_サポート = 7,
            
            NULL_ENUM_VALUE = 8,
        }
        
        public enum StatusInfoValues {
            
            その他 = 1,
            
            不明 = 2,
            
            有効 = 3,
            
            無効 = 4,
            
            該当なし = 5,
            
            NULL_ENUM_VALUE = 0,
        }
        
        // クラスのインスタンスを列挙する列挙子の実装です。
        public class BatteryCollection : object, ICollection {
            
            private ManagementObjectCollection privColObj;
            
            public BatteryCollection(ManagementObjectCollection objCollection) {
                privColObj = objCollection;
            }
            
            public virtual int Count {
                get {
                    return privColObj.Count;
                }
            }
            
            public virtual bool IsSynchronized {
                get {
                    return privColObj.IsSynchronized;
                }
            }
            
            public virtual object SyncRoot {
                get {
                    return this;
                }
            }
            
            public virtual void CopyTo(System.Array array, int index) {
                privColObj.CopyTo(array, index);
                int nCtr;
                for (nCtr = 0; (nCtr < array.Length); nCtr = (nCtr + 1)) {
                    array.SetValue(new Battery(((System.Management.ManagementObject)(array.GetValue(nCtr)))), nCtr);
                }
            }
            
            public virtual System.Collections.IEnumerator GetEnumerator() {
                return new BatteryEnumerator(privColObj.GetEnumerator());
            }
            
            public class BatteryEnumerator : object, System.Collections.IEnumerator {
                
                private ManagementObjectCollection.ManagementObjectEnumerator privObjEnum;
                
                public BatteryEnumerator(ManagementObjectCollection.ManagementObjectEnumerator objEnum) {
                    privObjEnum = objEnum;
                }
                
                public virtual object Current {
                    get {
                        return new Battery(((System.Management.ManagementObject)(privObjEnum.Current)));
                    }
                }
                
                public virtual bool MoveNext() {
                    return privObjEnum.MoveNext();
                }
                
                public virtual void Reset() {
                    privObjEnum.Reset();
                }
            }
        }
        
        // ValueType プロパティの NULL 値を扱う TypeConverter です。
        public class WMIValueTypeConverter : TypeConverter {
            
            private TypeConverter baseConverter;
            
            private System.Type baseType;
            
            public WMIValueTypeConverter(System.Type inBaseType) {
                baseConverter = TypeDescriptor.GetConverter(inBaseType);
                baseType = inBaseType;
            }
            
            public override bool CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type srcType) {
                return baseConverter.CanConvertFrom(context, srcType);
            }
            
            public override bool CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType) {
                return baseConverter.CanConvertTo(context, destinationType);
            }
            
            public override object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value) {
                return baseConverter.ConvertFrom(context, culture, value);
            }
            
            public override object CreateInstance(System.ComponentModel.ITypeDescriptorContext context, System.Collections.IDictionary dictionary) {
                return baseConverter.CreateInstance(context, dictionary);
            }
            
            public override bool GetCreateInstanceSupported(System.ComponentModel.ITypeDescriptorContext context) {
                return baseConverter.GetCreateInstanceSupported(context);
            }
            
            public override PropertyDescriptorCollection GetProperties(System.ComponentModel.ITypeDescriptorContext context, object value, System.Attribute[] attributeVar) {
                return baseConverter.GetProperties(context, value, attributeVar);
            }
            
            public override bool GetPropertiesSupported(System.ComponentModel.ITypeDescriptorContext context) {
                return baseConverter.GetPropertiesSupported(context);
            }
            
            public override System.ComponentModel.TypeConverter.StandardValuesCollection GetStandardValues(System.ComponentModel.ITypeDescriptorContext context) {
                return baseConverter.GetStandardValues(context);
            }
            
            public override bool GetStandardValuesExclusive(System.ComponentModel.ITypeDescriptorContext context) {
                return baseConverter.GetStandardValuesExclusive(context);
            }
            
            public override bool GetStandardValuesSupported(System.ComponentModel.ITypeDescriptorContext context) {
                return baseConverter.GetStandardValuesSupported(context);
            }
            
            public override object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, object value, System.Type destinationType) {
                if ((baseType.BaseType == typeof(System.Enum))) {
                    if ((value.GetType() == destinationType)) {
                        return value;
                    }
                    if ((((value == null) 
                                && (context != null)) 
                                && (context.PropertyDescriptor.ShouldSerializeValue(context.Instance) == false))) {
                        return  "NULL_ENUM_VALUE" ;
                    }
                    return baseConverter.ConvertTo(context, culture, value, destinationType);
                }
                if (((baseType == typeof(bool)) 
                            && (baseType.BaseType == typeof(System.ValueType)))) {
                    if ((((value == null) 
                                && (context != null)) 
                                && (context.PropertyDescriptor.ShouldSerializeValue(context.Instance) == false))) {
                        return "";
                    }
                    return baseConverter.ConvertTo(context, culture, value, destinationType);
                }
                if (((context != null) 
                            && (context.PropertyDescriptor.ShouldSerializeValue(context.Instance) == false))) {
                    return "";
                }
                return baseConverter.ConvertTo(context, culture, value, destinationType);
            }
        }
        
        // WMI システム プロパティを表す埋め込みクラスです。
        [TypeConverter(typeof(System.ComponentModel.ExpandableObjectConverter))]
        public class ManagementSystemProperties {
            
            private System.Management.ManagementBaseObject PrivateLateBoundObject;
            
            public ManagementSystemProperties(System.Management.ManagementBaseObject ManagedObject) {
                PrivateLateBoundObject = ManagedObject;
            }
            
            [Browsable(true)]
            public int GENUS {
                get {
                    return ((int)(PrivateLateBoundObject["__GENUS"]));
                }
            }
            
            [Browsable(true)]
            public string CLASS {
                get {
                    return ((string)(PrivateLateBoundObject["__CLASS"]));
                }
            }
            
            [Browsable(true)]
            public string SUPERCLASS {
                get {
                    return ((string)(PrivateLateBoundObject["__SUPERCLASS"]));
                }
            }
            
            [Browsable(true)]
            public string DYNASTY {
                get {
                    return ((string)(PrivateLateBoundObject["__DYNASTY"]));
                }
            }
            
            [Browsable(true)]
            public string RELPATH {
                get {
                    return ((string)(PrivateLateBoundObject["__RELPATH"]));
                }
            }
            
            [Browsable(true)]
            public int PROPERTY_COUNT {
                get {
                    return ((int)(PrivateLateBoundObject["__PROPERTY_COUNT"]));
                }
            }
            
            [Browsable(true)]
            public string[] DERIVATION {
                get {
                    return ((string[])(PrivateLateBoundObject["__DERIVATION"]));
                }
            }
            
            [Browsable(true)]
            public string SERVER {
                get {
                    return ((string)(PrivateLateBoundObject["__SERVER"]));
                }
            }
            
            [Browsable(true)]
            public string NAMESPACE {
                get {
                    return ((string)(PrivateLateBoundObject["__NAMESPACE"]));
                }
            }
            
            [Browsable(true)]
            public string PATH {
                get {
                    return ((string)(PrivateLateBoundObject["__PATH"]));
                }
            }
        }
    }
}
