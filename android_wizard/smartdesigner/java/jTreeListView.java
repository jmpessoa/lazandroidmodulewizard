package ml.smartware.apptreelistviewdemo1;


import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;

import android.app.Activity;
import android.content.Context;
import android.content.res.TypedArray;
import android.database.DataSetObserver;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Gravity;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.AdapterView;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.FrameLayout;
import android.widget.FrameLayout.LayoutParams;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;

/**
 * Exception thrown when there is a problem with configuring tree.
 * 
 */
/* public */
class TreeConfigurationException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    public TreeConfigurationException(final String detailMessage) {
        super(detailMessage);
    }
}

/**
 * The node being added is already in the tree.
 * 
 */
/* public */ 
class NodeAlreadyInTreeException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    public NodeAlreadyInTreeException(final String id, final String oldNode) {
        super("The node has already been added to the tree: " + id + ". Old node is:" + oldNode);
    }
}

/**
 * This exception is thrown when the tree does not contain node requested.
 * 
 */
/* public */ 
class NodeNotInTreeException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    public NodeNotInTreeException(final String id) {
        super("The tree does not contain the node specified: " + id);
    }
}

/**
 * Information about the node.
 * 
 * @param <T>
 *            type of the id for the tree
 */
/* public */ 
class TreeNodeInfo<T> {
    private final T id;
    private final int level;
    private final boolean withChildren;
    private final boolean visible;
    private final boolean expanded;

    /**
     * Creates the node information.
     * 
     * @param id
     *            id of the node
     * @param level
     *            level of the node
     * @param withChildren
     *            whether the node has children.
     * @param visible
     *            whether the tree node is visible.
     * @param expanded
     *            whether the tree node is expanded
     * 
     */
    public TreeNodeInfo(final T id, final int level,
            final boolean withChildren, final boolean visible,
            final boolean expanded) {
        super();
        this.id = id;
        this.level = level;
        this.withChildren = withChildren;
        this.visible = visible;
        this.expanded = expanded;
    }

    public T getId() {
        return id;
    }

    public boolean isWithChildren() {
        return withChildren;
    }

    public boolean isVisible() {
        return visible;
    }

    public boolean isExpanded() {
        return expanded;
    }

    public int getLevel() {
        return level;
    }

    @Override
    public String toString() {
        return "TreeNodeInfo [id=" + id + ", level=" + level
                + ", withChildren=" + withChildren + ", visible=" + visible
                + ", expanded=" + expanded + "]";
    }

}

/**
 * Manages information about state of the tree. It only keeps information about
 * tree elements, not the elements themselves.
 * 
 * @param <T>
 *            type of the identifier for nodes in the tree
 */
/* public */ 
interface TreeStateManager<T> extends Serializable {

    /**
     * Returns array of integers showing the location of the node in hierarchy.
     * It corresponds to heading numbering. {0,0,0} in 3 level node is the first
     * node {0,0,1} is second leaf (assuming that there are two leaves in first
     * subnode of the first node).
     * 
     * @param id
     *            id of the node
     * @return textual description of the hierarchy in tree for the node.
     */
    Integer[] getHierarchyDescription(T id);

    /**
     * Returns level of the node.
     * 
     * @param id
     *            id of the node
     * @return level in the tree
     */
    int getLevel(T id);

    /**
     * Returns information about the node.
     * 
     * @param id
     *            node id
     * @return node info
     */
    TreeNodeInfo<T> getNodeInfo(T id);

    /**
     * Returns children of the node.
     * 
     * @param id
     *            id of the node or null if asking for top nodes
     * @return children of the node
     */
    List<T> getChildren(T id);

    /**
     * Returns parent of the node.
     * 
     * @param id
     *            id of the node
     * @return parent id or null if no parent
     */
    T getParent(T id);

    /**
     * Adds the node before child or at the beginning.
     * 
     * @param parent
     *            id of the parent node. If null - adds at the top level
     * @param newChild
     *            new child to add if null - adds at the beginning.
     * @param beforeChild
     *            child before which to add the new child
     */
    void addBeforeChild(T parent, T newChild, T beforeChild);

    /**
     * Adds the node after child or at the end.
     * 
     * @param parent
     *            id of the parent node. If null - adds at the top level.
     * @param newChild
     *            new child to add. If null - adds at the end.
     * @param afterChild
     *            child after which to add the new child
     */
    void addAfterChild(T parent, T newChild, T afterChild);

    /**
     * Removes the node and all children from the tree.
     * 
     * @param id
     *            id of the node to remove or null if all nodes are to be
     *            removed.
     */
    void removeNodeRecursively(T id);

    /**
     * Expands all children of the node.
     * 
     * @param id
     *            node which children should be expanded. cannot be null (top
     *            nodes are always expanded!).
     */
    void expandDirectChildren(T id);

    /**
     * Expands everything below the node specified. Might be null - then expands
     * all.
     * 
     * @param id
     *            node which children should be expanded or null if all nodes
     *            are to be expanded.
     */
    void expandEverythingBelow(T id);

    /**
     * Collapse children.
     * 
     * @param id
     *            id collapses everything below node specified. If null,
     *            collapses everything but top-level nodes.
     */
    void collapseChildren(T id);

    /**
     * Returns next sibling of the node (or null if no further sibling).
     * 
     * @param id
     *            node id
     * @return the sibling (or null if no next)
     */
    T getNextSibling(T id);

    /**
     * Returns previous sibling of the node (or null if no previous sibling).
     * 
     * @param id
     *            node id
     * @return the sibling (or null if no previous)
     */
    T getPreviousSibling(T id);

    /**
     * Checks if given node is already in tree.
     * 
     * @param id
     *            id of the node
     * @return true if node is already in tree.
     */
    boolean isInTree(T id);

    /**
     * Count visible elements.
     * 
     * @return number of currently visible elements.
     */
    int getVisibleCount();

    /**
     * Returns visible node list.
     * 
     * @return return the list of all visible nodes in the right sequence
     */
    List<T> getVisibleList();

    /**
     * Registers observers with the manager.
     * 
     * @param observer
     *            observer
     */
    void registerDataSetObserver(final DataSetObserver observer);

    /**
     * Unregisters observers with the manager.
     * 
     * @param observer
     *            observer
     */
    void unregisterDataSetObserver(final DataSetObserver observer);

    /**
     * Cleans tree stored in manager. After this operation the tree is empty.
     * 
     */
    void clear();

    /**
     * Refreshes views connected to the manager.
     */
    void refresh();
}

/**
 * Node. It is package protected so that it cannot be used outside.
 * 
 * @param <T>
 *            type of the identifier used by the tree
 */
class InMemoryTreeNode<T> implements Serializable {  // 'borrowed' from pl.polidea.treeview.InMemoryTreeNode
    private static final long serialVersionUID = 1L;
    private final T id;
    private final T parent;
    private final int level;
	
    private boolean visible = true;
    private final List<InMemoryTreeNode<T>> children = new LinkedList<InMemoryTreeNode<T>>();
    private List<T> childIdListCache = null;

    public InMemoryTreeNode(final T id, final T parent, final int level, final boolean visible) {
        super();
        this.id = id;
        this.parent = parent;
        this.level = level;
        this.visible = visible;
    }

    public int indexOf(final T id) {
        return getChildIdList().indexOf(id);
    }

    /**
     * Cache is built lazily only if needed. The cache is cleaned on any
     * structure change for that node!).
     * 
     * @return list of ids of children
     */
    public synchronized List<T> getChildIdList() {
        if (childIdListCache == null) {
            childIdListCache = new LinkedList<T>();
            for (final InMemoryTreeNode<T> n : children) {
                childIdListCache.add(n.getId());
            }
        }
        return childIdListCache;
    }

    public boolean isVisible() {
        return visible;
    }

    public void setVisible(final boolean visible) {
        this.visible = visible;
    }

    public int getChildrenListSize() {
        return children.size();
    }

    public synchronized InMemoryTreeNode<T> add(final int index, final T child, final boolean visible) {
        childIdListCache = null;
        // Note! top level children are always visible (!)
        final InMemoryTreeNode<T> newNode = new InMemoryTreeNode<T>(child,
                getId(), getLevel() + 1, getId() == null ? true : visible);
        children.add(index, newNode);
        return newNode;
    }

    /**
     * Note. This method should technically return unmodifiable collection, but
     * for performance reason on small devices we do not do it.
     * 
     * @return children list
     */
    public List<InMemoryTreeNode<T>> getChildren() {
        return children;
    }

    public synchronized void clearChildren() {
        children.clear();
        childIdListCache = null;
    }

    public synchronized void removeChild(final T child) {
        final int childIndex = indexOf(child);
        if (childIndex != -1) {
            children.remove(childIndex);
            childIdListCache = null;
        }
    }

    @Override
    public String toString() {
        return "InMemoryTreeNode [id=" + getId() + ", parent=" + getParent()
                + ", level=" + getLevel() + ", visible=" + visible 
                + ", children=" + children + ", childIdListCache="
                + childIdListCache + "]";
    }

    T getId() {
        return id;
    }

    T getParent() {
        return parent;
    }

    int getLevel() {
        return level;
    }
}

/**
 * In-memory manager of tree state.
 * 
 * @param <T>
 *            type of identifier
 */
/* public */ 
class InMemoryTreeStateManager<T> implements TreeStateManager<T> {
    private static final String TAG = InMemoryTreeStateManager.class
            .getSimpleName();
    private static final long serialVersionUID = 1L;
    private final Map<T, InMemoryTreeNode<T>> allNodes = new HashMap<T, InMemoryTreeNode<T>>();
    private final InMemoryTreeNode<T> topSentinel = new InMemoryTreeNode<T>(
            null, null, -1, true);
    private transient List<T> visibleListCache = null; // lasy initialised
    private transient List<T> unmodifiableVisibleList = null;
    private boolean visibleByDefault = true;
    private final transient Set<DataSetObserver> observers = new HashSet<DataSetObserver>();

    private synchronized void internalDataSetChanged() {
        visibleListCache = null;
        unmodifiableVisibleList = null;
        for (final DataSetObserver observer : observers) {
            observer.onChanged();
        }
    }

    /**
     * If true new nodes are visible by default.
     * 
     * @param visibleByDefault
     *            if true, then newly added nodes are expanded by default
     */
    public void setVisibleByDefault(final boolean visibleByDefault) {
        this.visibleByDefault = visibleByDefault;
    }

    private InMemoryTreeNode<T> getNodeFromTreeOrThrow(final T id) {
        if (id == null) {
            throw new NodeNotInTreeException("(null)");
        }
        final InMemoryTreeNode<T> node = allNodes.get(id);
        if (node == null) {
            throw new NodeNotInTreeException(id.toString());
        }
        return node;
    }

    private InMemoryTreeNode<T> getNodeFromTreeOrThrowAllowRoot(final T id) {
        if (id == null) {
            return topSentinel;
        }
        return getNodeFromTreeOrThrow(id);
    }

    private void expectNodeNotInTreeYet(final T id) {
        final InMemoryTreeNode<T> node = allNodes.get(id);
        if (node != null) {
            throw new NodeAlreadyInTreeException(id.toString(), node.toString());
        }
    }

    @Override
    public synchronized TreeNodeInfo<T> getNodeInfo(final T id) {
        final InMemoryTreeNode<T> node = getNodeFromTreeOrThrow(id);
        final List<InMemoryTreeNode<T>> children = node.getChildren();
        boolean expanded = false;
        if (!children.isEmpty() && children.get(0).isVisible()) {
            expanded = true;
        }
        return new TreeNodeInfo<T>(id, node.getLevel(), !children.isEmpty(),
                node.isVisible(), expanded);
    }

    @Override
    public synchronized List<T> getChildren(final T id) {
        final InMemoryTreeNode<T> node = getNodeFromTreeOrThrowAllowRoot(id);
        return node.getChildIdList();
    }

    @Override
    public synchronized T getParent(final T id) {
        final InMemoryTreeNode<T> node = getNodeFromTreeOrThrowAllowRoot(id);
        return node.getParent();
    }

    private boolean getChildrenVisibility(final InMemoryTreeNode<T> node) {
        boolean visibility;
        final List<InMemoryTreeNode<T>> children = node.getChildren();
        if (children.isEmpty()) {
            visibility = visibleByDefault;
        } else {
            visibility = children.get(0).isVisible();
        }
        return visibility;
    }

    @Override
    public synchronized void addBeforeChild(final T parent, final T newChild,
            final T beforeChild) {
        expectNodeNotInTreeYet(newChild);
        final InMemoryTreeNode<T> node = getNodeFromTreeOrThrowAllowRoot(parent);
        final boolean visibility = getChildrenVisibility(node);
        // top nodes are always expanded.
        if (beforeChild == null) {
            final InMemoryTreeNode<T> added = node.add(0, newChild, visibility);
            allNodes.put(newChild, added);
        } else {
            final int index = node.indexOf(beforeChild);
            final InMemoryTreeNode<T> added = node.add(index == -1 ? 0 : index,
                    newChild, visibility);
            allNodes.put(newChild, added);
        }
        if (visibility) {
            internalDataSetChanged();
        }
    }

    @Override
    public synchronized void addAfterChild(final T parent, final T newChild,
            final T afterChild) {
        expectNodeNotInTreeYet(newChild);
        final InMemoryTreeNode<T> node = getNodeFromTreeOrThrowAllowRoot(parent);
        final boolean visibility = getChildrenVisibility(node);
        if (afterChild == null) {
            final InMemoryTreeNode<T> added = node.add(
                    node.getChildrenListSize(), newChild, visibility);
            allNodes.put(newChild, added);
        } else {
            final int index = node.indexOf(afterChild);
            final InMemoryTreeNode<T> added = node.add(
                    index == -1 ? node.getChildrenListSize() : index + 1, newChild,
                    visibility);
            allNodes.put(newChild, added);
        }
        if (visibility) {
            internalDataSetChanged();
        }
    }

    @Override
    public synchronized void removeNodeRecursively(final T id) {
        final InMemoryTreeNode<T> node = getNodeFromTreeOrThrowAllowRoot(id);
        final boolean visibleNodeChanged = removeNodeRecursively(node);
        final T parent = node.getParent();
        final InMemoryTreeNode<T> parentNode = getNodeFromTreeOrThrowAllowRoot(parent);
        parentNode.removeChild(id);
        if (visibleNodeChanged) {
            internalDataSetChanged();
        }
    }

    private boolean removeNodeRecursively(final InMemoryTreeNode<T> node) {
        boolean visibleNodeChanged = false;
        for (final InMemoryTreeNode<T> child : node.getChildren()) {
            if (removeNodeRecursively(child)) {
                visibleNodeChanged = true;
            }
        }
        node.clearChildren();
        if (node.getId() != null) {
            allNodes.remove(node.getId());
            if (node.isVisible()) {
                visibleNodeChanged = true;
            }
        }
        return visibleNodeChanged;
    }

    private void setChildrenVisibility(final InMemoryTreeNode<T> node,
            final boolean visible, final boolean recursive) {
        for (final InMemoryTreeNode<T> child : node.getChildren()) {
            child.setVisible(visible);
            if (recursive) {
                setChildrenVisibility(child, visible, true);
            }
        }
    }

    @Override
    public synchronized void expandDirectChildren(final T id) {
        // Log.d(TAG, "Expanding direct children of " + id);
        final InMemoryTreeNode<T> node = getNodeFromTreeOrThrowAllowRoot(id);
        setChildrenVisibility(node, true, false);
        internalDataSetChanged();
    }

    @Override
    public synchronized void expandEverythingBelow(final T id) {
        // Log.d(TAG, "Expanding all children below " + id);
        final InMemoryTreeNode<T> node = getNodeFromTreeOrThrowAllowRoot(id);
        setChildrenVisibility(node, true, true);
        internalDataSetChanged();
    }

    @Override
    public synchronized void collapseChildren(final T id) {
        final InMemoryTreeNode<T> node = getNodeFromTreeOrThrowAllowRoot(id);
        if (node == topSentinel) {
            for (final InMemoryTreeNode<T> n : topSentinel.getChildren()) {
                setChildrenVisibility(n, false, true);
            }
        } else {
            setChildrenVisibility(node, false, true);
        }
        internalDataSetChanged();
    }

    @Override
    public synchronized T getNextSibling(final T id) {
        final T parent = getParent(id);
        final InMemoryTreeNode<T> parentNode = getNodeFromTreeOrThrowAllowRoot(parent);
        boolean returnNext = false;
        for (final InMemoryTreeNode<T> child : parentNode.getChildren()) {
            if (returnNext) {
                return child.getId();
            }
            if (child.getId().equals(id)) {
                returnNext = true;
            }
        }
        return null;
    }

    @Override
    public synchronized T getPreviousSibling(final T id) {
        final T parent = getParent(id);
        final InMemoryTreeNode<T> parentNode = getNodeFromTreeOrThrowAllowRoot(parent);
        T previousSibling = null;
        for (final InMemoryTreeNode<T> child : parentNode.getChildren()) {
            if (child.getId().equals(id)) {
                return previousSibling;
            }
            previousSibling = child.getId();
        }
        return null;
    }

    @Override
    public synchronized boolean isInTree(final T id) {
        return allNodes.containsKey(id);
    }

    @Override
    public synchronized int getVisibleCount() {
        return getVisibleList().size();
    }

    @Override
    public synchronized List<T> getVisibleList() {
        T currentId = null;
        if (visibleListCache == null) {
            visibleListCache = new ArrayList<T>(allNodes.size());
            do {
                currentId = getNextVisible(currentId);
                if (currentId == null) {
                    break;
                } else {
                    visibleListCache.add(currentId);
                }
            } while (true);
        }
        if (unmodifiableVisibleList == null) {
            unmodifiableVisibleList = Collections
                    .unmodifiableList(visibleListCache);
        }
        return unmodifiableVisibleList;
    }

    public synchronized T getNextVisible(final T id) {
        final InMemoryTreeNode<T> node = getNodeFromTreeOrThrowAllowRoot(id);
        if (!node.isVisible()) {
            return null;
        }
        final List<InMemoryTreeNode<T>> children = node.getChildren();
        if (!children.isEmpty()) {
            final InMemoryTreeNode<T> firstChild = children.get(0);
            if (firstChild.isVisible()) {
                return firstChild.getId();
            }
        }
        final T sibl = getNextSibling(id);
        if (sibl != null) {
            return sibl;
        }
        T parent = node.getParent();
        do {
            if (parent == null) {
                return null;
            }
            final T parentSibling = getNextSibling(parent);
            if (parentSibling != null) {
                return parentSibling;
            }
            parent = getNodeFromTreeOrThrow(parent).getParent();
        } while (true);
    }

    @Override
    public synchronized void registerDataSetObserver(
            final DataSetObserver observer) {
        observers.add(observer);
    }

    @Override
    public synchronized void unregisterDataSetObserver(
            final DataSetObserver observer) {
        observers.remove(observer);
    }

    @Override
    public int getLevel(final T id) {
        return getNodeFromTreeOrThrow(id).getLevel();
    }

    @Override
    public Integer[] getHierarchyDescription(final T id) {
        final int level = getLevel(id);
        final Integer[] hierarchy = new Integer[level + 1];
        int currentLevel = level;
        T currentId = id;
        T parent = getParent(currentId);
        while (currentLevel >= 0) {
            hierarchy[currentLevel--] = getChildren(parent).indexOf(currentId);
            currentId = parent;
            parent = getParent(parent);
        }
        return hierarchy;
    }

    private void appendToSb(final StringBuilder sb, final T id) {
        if (id != null) {
            final TreeNodeInfo<T> node = getNodeInfo(id);
            final int indent = node.getLevel() * 4;
            final char[] indentString = new char[indent];
            Arrays.fill(indentString, ' ');
            sb.append(indentString);
            sb.append(node.toString());
            sb.append(Arrays.asList(getHierarchyDescription(id)).toString());
            sb.append("\n");
        }
        final List<T> children = getChildren(id);
        for (final T child : children) {
            appendToSb(sb, child);
        }
    }

    @Override
    public synchronized String toString() {
        final StringBuilder sb = new StringBuilder();
        appendToSb(sb, null);
        return sb.toString();
    }

    @Override
    public synchronized void clear() {
        allNodes.clear();
        topSentinel.clearChildren();
        internalDataSetChanged();
    }

    @Override
    public void refresh() {
        internalDataSetChanged();
    }

}

/**
 * Adapter used to feed the table view.
 * 
 * @param <T>
 *            class for ID of the tree
 */
/* public */ 
abstract class AbstractTreeViewAdapter<T> extends BaseAdapter implements ListAdapter {
    private static final String TAG = AbstractTreeViewAdapter.class.getSimpleName();
    private final TreeStateManager<T> treeStateManager;
    private final int numberOfLevels;
    private final LayoutInflater layoutInflater;

    private int indentWidth = 0;
    private int indicatorGravity = 0;
    private Drawable collapsedDrawable;
    private Drawable expandedDrawable;
    private Drawable indicatorBackgroundDrawable;
    private Drawable rowBackgroundDrawable;

    private boolean collapsible;
    private final Activity activity;

    private final OnClickListener indicatorClickListener = new OnClickListener() {
        @Override
        public void onClick(final View v) {
            @SuppressWarnings("unchecked")
            final T id = (T) v.getTag();
            expandCollapse(id);
        }
    };

    protected void expandCollapse(final T id) {
        final TreeNodeInfo<T> info = treeStateManager.getNodeInfo(id);
        if (!info.isWithChildren()) {
            // ignore - no default action
            return;
        }
        if (info.isExpanded()) {
            treeStateManager.collapseChildren(id);
        } else {
            treeStateManager.expandDirectChildren(id);
        }
    }

    public AbstractTreeViewAdapter(final Activity activity,
            final TreeStateManager<T> treeStateManager, final int numberOfLevels) {
        this.activity = activity;
        this.treeStateManager = treeStateManager;
        this.layoutInflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        this.numberOfLevels = numberOfLevels;
        this.collapsedDrawable = null;
        this.expandedDrawable = null;
        this.rowBackgroundDrawable = null;
        this.indicatorBackgroundDrawable = null;
    }

    public Activity getActivity() {
        return activity;
    }

    protected TreeStateManager<T> getManager() {
        return treeStateManager;
    }

    private void calculateIndentWidth() {
        if (expandedDrawable != null) {
            indentWidth = Math.max(getIndentWidth(), expandedDrawable.getIntrinsicWidth());
        }
        if (collapsedDrawable != null) {
            indentWidth = Math.max(getIndentWidth(), collapsedDrawable.getIntrinsicWidth());
        }
    }

    @Override
    public void registerDataSetObserver(final DataSetObserver observer) {
        treeStateManager.registerDataSetObserver(observer);
    }

    @Override
    public void unregisterDataSetObserver(final DataSetObserver observer) {
        treeStateManager.unregisterDataSetObserver(observer);
    }

    @Override
    public int getCount() {
        return treeStateManager.getVisibleCount();
    }

    public T getTreeId(final int position) {
        return treeStateManager.getVisibleList().get(position);
    }

    @Override
    public Object getItem(final int position) {
        return getTreeId(position);
    }

    public TreeNodeInfo<T> getTreeNodeInfo(final int position) {
        return treeStateManager.getNodeInfo(getTreeId(position));
    }

    @Override
    public int getItemViewType(final int position) {
        return getTreeNodeInfo(position).getLevel();
    }

    @Override
    public int getViewTypeCount() {
        return numberOfLevels;
    }

    @Override
    public boolean hasStableIds() { // NOPMD
        return true;
    }

    @Override
    public boolean isEmpty() {
        return getCount() == 0;
    }

    @Override
    public boolean isEnabled(final int position) { // NOPMD
        return true;
    }

    @Override
    public boolean areAllItemsEnabled() { // NOPMD
        return true;
    }

    protected int getTreeListItemWrapperId() {
        return R.layout.tree_list_item_wrapper;
    }

    /**
     * Called when new view is to be created.
     * 
     * @param treeNodeInfo
     *            node info
     * @return view that should be displayed as tree content
     */
    public abstract View getNewChildView(TreeNodeInfo<T> treeNodeInfo);

    /**
     * Called when new view is going to be reused. You should update the view
     * and fill it in with the data required to display the new information. You
     * can also create a new view, which will mean that the old view will not be
     * reused.
     * 
     * @param view
     *            view that should be updated with the new values
     * @param treeNodeInfo
     *            node info used to populate the view
     * @return view to used as row indented content
     */
    public abstract View updateView(View view, TreeNodeInfo<T> treeNodeInfo);

    @Override
    public final View getView(final int position, final View convertView, final ViewGroup parent) {
		final LinearLayout layout;
		final View childView;
        // Log.d(TAG, "Creating a view based on " + convertView + " with position " + position);
        final TreeNodeInfo<T> nodeInfo = getTreeNodeInfo(position);
		final boolean needNew = convertView == null;
        if (needNew) {
            // Log.d(TAG, "Creating new view");
            layout = (LinearLayout) layoutInflater.inflate(getTreeListItemWrapperId(), null);
			childView = getNewChildView(nodeInfo);
        } else {
            // Log.d(TAG, "Reusing the view");
            layout = (LinearLayout) convertView;
            final FrameLayout frameLayout = (FrameLayout) layout.findViewById(R.id.treeview_list_item_frame);
            childView = frameLayout.getChildAt(0);
            updateView(childView, nodeInfo);
        }
        return populateTreeItem(layout, childView, nodeInfo, needNew);
    }

    /**
     * Retrieves background drawable for the node.
     * 
     * @param treeNodeInfo
     *            node info
     * @return drawable returned as background for the whole row. Might be null,
     *         then default background is used
     */
    public Drawable getBackgroundDrawable(final TreeNodeInfo<T> treeNodeInfo) { // NOPMD
        return null;
    }

    private Drawable getDrawableOrDefaultBackground(final Drawable r) {
        if (r == null) {
            return activity.getResources().getDrawable(R.drawable.list_selector_background).mutate();
        } else {
            return r;
        }
    }

    private int getIndentWidth() {
        return indentWidth;
    }

    protected int calculateIndentation(final TreeNodeInfo<T> nodeInfo) {
        return getIndentWidth() * (nodeInfo.getLevel() + (collapsible ? 1 : 0));
    }

    protected Drawable getDrawable(final TreeNodeInfo<T> nodeInfo) {
        if (!nodeInfo.isWithChildren() || !collapsible) {
            return getDrawableOrDefaultBackground(indicatorBackgroundDrawable);
        }
        if (nodeInfo.isExpanded()) {
            return expandedDrawable;
        } else {
            return collapsedDrawable;
        }
    }

    public final LinearLayout populateTreeItem(final LinearLayout layout,
            final View childView, final TreeNodeInfo<T> nodeInfo, final boolean newChildView) {
        final Drawable individualRowDrawable = getBackgroundDrawable(nodeInfo);
        layout.setBackgroundDrawable(individualRowDrawable == null ? getDrawableOrDefaultBackground(rowBackgroundDrawable)
                : individualRowDrawable);
        final LinearLayout.LayoutParams indicatorLayoutParams 
			= new LinearLayout.LayoutParams(calculateIndentation(nodeInfo), LayoutParams.FILL_PARENT);
        final LinearLayout indicatorLayout = (LinearLayout) layout.findViewById(R.id.treeview_list_item_image_layout);
        indicatorLayout.setGravity(indicatorGravity);
        indicatorLayout.setLayoutParams(indicatorLayoutParams);
        final ImageView image = (ImageView) layout.findViewById(R.id.treeview_list_item_image);
        image.setImageDrawable(getDrawable(nodeInfo));
        image.setBackgroundDrawable(getDrawableOrDefaultBackground(indicatorBackgroundDrawable));
        image.setScaleType(ScaleType.CENTER);
        image.setTag(nodeInfo.getId());
        if (nodeInfo.isWithChildren() && collapsible) {
            image.setOnClickListener(indicatorClickListener);
        } else {
            image.setOnClickListener(null);
        }
        layout.setTag(nodeInfo.getId());
        final FrameLayout frameLayout = (FrameLayout) layout.findViewById(R.id.treeview_list_item_frame);
        final FrameLayout.LayoutParams childParams
			= new FrameLayout.LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT);
        if (newChildView) {
            frameLayout.addView(childView, childParams);
        }
        frameLayout.setTag(nodeInfo.getId());
        return layout;
    }

    public void setIndicatorGravity(final int indicatorGravity) {
        this.indicatorGravity = indicatorGravity;
    }

    public void setCollapsedDrawable(final Drawable collapsedDrawable) {
        this.collapsedDrawable = collapsedDrawable;
        calculateIndentWidth();
    }

    public void setExpandedDrawable(final Drawable expandedDrawable) {
        this.expandedDrawable = expandedDrawable;
        calculateIndentWidth();
    }

    public void setIndentWidth(final int indentWidth) {
        this.indentWidth = indentWidth;
        calculateIndentWidth();
    }

    public void setRowBackgroundDrawable(final Drawable rowBackgroundDrawable) {
        this.rowBackgroundDrawable = rowBackgroundDrawable;
    }

    public void setIndicatorBackgroundDrawable(final Drawable indicatorBackgroundDrawable) {
        this.indicatorBackgroundDrawable = indicatorBackgroundDrawable;
    }

    public void setCollapsible(final boolean collapsible) {
        this.collapsible = collapsible;
    }

    public void refresh() {
        treeStateManager.refresh();
    }

    @SuppressWarnings("unchecked")
    public void handleItemClick(final View view, final Object id) {
		Log.i("AbstractTreeViewAdapter", "handleItemClick of item "+((T)id));
        expandCollapse((T) id);
    }

}

/**
 * Tree view, expandable multi-level.
 * 
 * <pre>
 * attr ref pl.polidea.treeview.R.styleable#TreeViewList_collapsible
 * attr ref pl.polidea.treeview.R.styleable#TreeViewList_src_expanded
 * attr ref pl.polidea.treeview.R.styleable#TreeViewList_src_collapsed
 * attr ref pl.polidea.treeview.R.styleable#TreeViewList_indent_width
 * attr ref pl.polidea.treeview.R.styleable#TreeViewList_handle_trackball_press
 * attr ref pl.polidea.treeview.R.styleable#TreeViewList_indicator_gravity
 * attr ref pl.polidea.treeview.R.styleable#TreeViewList_indicator_background
 * attr ref pl.polidea.treeview.R.styleable#TreeViewList_row_background
 * </pre>
 */

class TreeViewList extends ListView {
    private static final int DEFAULT_COLLAPSED_RESOURCE = R.drawable.collapsed;
    private static final int DEFAULT_EXPANDED_RESOURCE = R.drawable.expanded;
    private static final int DEFAULT_INDENT = 0;
    private static final int DEFAULT_GRAVITY = Gravity.LEFT | Gravity.CENTER_VERTICAL;
    private Drawable expandedDrawable;
    private Drawable collapsedDrawable;
    private Drawable rowBackgroundDrawable;
    private Drawable indicatorBackgroundDrawable;
    private int indentWidth = 0;
    private int indicatorGravity = 0;
    private AbstractTreeViewAdapter< ? > treeAdapter;
    private boolean collapsible;
    private boolean handleTrackballPress;

    public TreeViewList(final Context context) {
        this(context, null);
    }

    public TreeViewList(final Context context, final AttributeSet attrs) {
        this(context, attrs, R.style.treeViewListStyle);
    }

    public TreeViewList(final Context context, final AttributeSet attrs, final int defStyle) {
        super(context, attrs, defStyle);
        parseAttributes(context, attrs);
    }

    private void parseAttributes(final Context context, final AttributeSet attrs) {
        final TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.TreeViewList);
		try {
			expandedDrawable = a.getDrawable(R.styleable.TreeViewList_src_expanded);
			if (expandedDrawable == null) {
				expandedDrawable = context.getResources().getDrawable(DEFAULT_EXPANDED_RESOURCE);
			}
			collapsedDrawable = a.getDrawable(R.styleable.TreeViewList_src_collapsed);
			if (collapsedDrawable == null) {
				collapsedDrawable = context.getResources().getDrawable(DEFAULT_COLLAPSED_RESOURCE);
			}
			indentWidth = a.getDimensionPixelSize(R.styleable.TreeViewList_indent_width, DEFAULT_INDENT);
			indicatorGravity = a.getInteger(R.styleable.TreeViewList_indicator_gravity, DEFAULT_GRAVITY);
			indicatorBackgroundDrawable = a.getDrawable(R.styleable.TreeViewList_indicator_background);
			rowBackgroundDrawable = a.getDrawable(R.styleable.TreeViewList_row_background);
			collapsible = a.getBoolean(R.styleable.TreeViewList_collapsible, true);
			handleTrackballPress = a.getBoolean(R.styleable.TreeViewList_handle_trackball_press, false);
			
			// Log.i("TreeViewList", "handleTrackballPress from Resources is "+handleTrackballPress);
		}
		finally {
			a.recycle();
		}
    }

    @Override
    public void setAdapter(final ListAdapter adapter) {
        if (!(adapter instanceof AbstractTreeViewAdapter)) {
            throw new TreeConfigurationException("The adapter is not of TreeViewAdapter type");
        }
        treeAdapter = (AbstractTreeViewAdapter< ? >) adapter;
        syncAdapter();
        super.setAdapter(treeAdapter);
    }

    private void syncAdapter() {
        treeAdapter.setCollapsedDrawable(collapsedDrawable);
        treeAdapter.setExpandedDrawable(expandedDrawable);
        treeAdapter.setIndicatorGravity(indicatorGravity);
        treeAdapter.setIndentWidth(indentWidth);
        treeAdapter.setIndicatorBackgroundDrawable(indicatorBackgroundDrawable);
        treeAdapter.setRowBackgroundDrawable(rowBackgroundDrawable);
        treeAdapter.setCollapsible(collapsible);
/*         if (handleTrackballPress) {
            setOnItemClickListener(new OnItemClickListener() {
                @Override
                public void onItemClick(final AdapterView< ? > parent,
                        final View view, final int position, final long id) {
					Log.i("TreeViewList", "onItemClick of item "+id+" at position "+position);
                    treeAdapter.handleItemClick(view, view.getTag());
                }
            });
        } else {
            setOnItemClickListener(null);
        }
 */    }

    public void setExpandedDrawable(final Drawable expandedDrawable) {
        this.expandedDrawable = expandedDrawable;
        syncAdapter();
        treeAdapter.refresh();
    }

    public void setCollapsedDrawable(final Drawable collapsedDrawable) {
        this.collapsedDrawable = collapsedDrawable;
        syncAdapter();
        treeAdapter.refresh();
    }

    public void setRowBackgroundDrawable(final Drawable rowBackgroundDrawable) {
        this.rowBackgroundDrawable = rowBackgroundDrawable;
        syncAdapter();
        treeAdapter.refresh();
    }

    public void setIndicatorBackgroundDrawable(
            final Drawable indicatorBackgroundDrawable) {
        this.indicatorBackgroundDrawable = indicatorBackgroundDrawable;
        syncAdapter();
        treeAdapter.refresh();
    }

    public void setIndentWidth(final int indentWidth) {
        this.indentWidth = indentWidth;
        syncAdapter();
        treeAdapter.refresh();
    }

    public void setIndicatorGravity(final int indicatorGravity) {
        this.indicatorGravity = indicatorGravity;
        syncAdapter();
        treeAdapter.refresh();
    }

    public void setCollapsible(final boolean collapsible) {
        this.collapsible = collapsible;
        syncAdapter();
        treeAdapter.refresh();
    }

    public void setHandleTrackballPress(final boolean handleTrackballPress) {
        this.handleTrackballPress = handleTrackballPress;
        syncAdapter();
        treeAdapter.refresh();
    }

    public Drawable getExpandedDrawable() {
        return expandedDrawable;
    }

    public Drawable getCollapsedDrawable() {
        return collapsedDrawable;
    }

    public Drawable getRowBackgroundDrawable() {
        return rowBackgroundDrawable;
    }

    public Drawable getIndicatorBackgroundDrawable() {
        return indicatorBackgroundDrawable;
    }

    public int getIndentWidth() {
        return indentWidth;
    }

    public int getIndicatorGravity() {
        return indicatorGravity;
    }

    public boolean isCollapsible() {
        return collapsible;
    }

    public boolean isHandleTrackballPress() {
        return handleTrackballPress;
    }

}

/*Draft java code by "Lazarus Android Module Wizard" [19/02/2018 09:41:41]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
  
class jTreeViewAdapter extends AbstractTreeViewAdapter<Long> {

    private final Set<Long> selected;
	private int mNumberOfLevels = 1;
	
	private jTreeListView mClient = null;
	
    private final OnCheckedChangeListener onCheckedChange = new OnCheckedChangeListener() {
        @Override
        public void onCheckedChanged(final CompoundButton buttonView, final boolean isChecked) {
            final Long id = (Long) buttonView.getTag();
            changeSelected(isChecked, id);
        }
    };

    private void changeSelected(final boolean isChecked, final Long id) {
        if (isChecked) {
            selected.add(id);
        } else {
            selected.remove(id);
        }
    }

    public jTreeViewAdapter(final Activity activity, final jTreeListView owner, 
            final Set<Long> selected,
            final TreeStateManager<Long> treeStateManager,
            final int numberOfLevels) {
        super(activity, treeStateManager, numberOfLevels);
		this.mClient = owner;
        this.selected = selected;
    }

	public void setLevels(int count) {
		mNumberOfLevels = count;
	}
	
    @Override
    public int getViewTypeCount() {
        return mNumberOfLevels;
    }
	
    private String getDescription(final long id) {
		return mClient.GetNodeData((int)id);
    }

    @Override
    public View getNewChildView(final TreeNodeInfo<Long> treeNodeInfo) {
        final LinearLayout viewLayout =
			(LinearLayout) getActivity().getLayoutInflater().inflate(R.layout.demo_list_item, null);
        return updateView(viewLayout, treeNodeInfo);
    }

    @Override
    public LinearLayout updateView(final View view, final TreeNodeInfo<Long> treeNodeInfo) {
        final LinearLayout viewLayout = (LinearLayout) view;
        final TextView descriptionView = (TextView) viewLayout.findViewById(R.id.demo_list_item_description);
        descriptionView.setText(getDescription(treeNodeInfo.getId()));
        // final TextView levelView = (TextView) viewLayout.findViewById(R.id.demo_list_item_level);
        // levelView.setText(Integer.toString(treeNodeInfo.getLevel()));
        final CheckBox box = (CheckBox) viewLayout.findViewById(R.id.demo_list_checkbox);
        box.setTag(treeNodeInfo.getId());
        if (treeNodeInfo.isWithChildren()) {
            box.setVisibility(View.GONE);
        } else {
            box.setVisibility(View.VISIBLE);
            box.setChecked(selected.contains(treeNodeInfo.getId()));
        }
        box.setOnCheckedChangeListener(onCheckedChange);
        return viewLayout;
    }

    @Override
    public void handleItemClick(final View view, final Object id) {
        final Long longId = (Long) id;
        final TreeNodeInfo<Long> info = getManager().getNodeInfo(longId);
		Log.i("jTreeViewAdapter", "handleItemClick of item "+longId);
        if (info.isWithChildren()) {
            super.handleItemClick(view, id);
        } else {
            final ViewGroup vg = (ViewGroup) view;
            final CheckBox cb = (CheckBox) vg.findViewById(R.id.demo_list_checkbox);
            cb.performClick();
        }
    }

    @Override
    public long getItemId(final int position) {
        return getTreeId(position);
    }
}

public class jTreeListView extends TreeViewList {
 
    private long     pascalObj = 0;        // Pascal Object
    private Controls controls  = null;     // Java/Pascal [events] Interface ...
    private jCommons LAMWCommon;
    private Context  context = null;
 
	private static final Long ROOT = new Long(0xffffffff);
	
    private final Set<Long> mSelected = new HashSet<Long>();
    private InMemoryTreeStateManager<Long> mManager = null;
    private jTreeViewAdapter mSimpleAdapter;
	private long mLastAddedId = 0;
	private long mFocusedNode = 0;
	
	private final Map<Integer, String> Captions = new HashMap<Integer, String>(100);
	
    // private OnClickListener onClickListener;             // click event
    private OnItemClickListener onItemClickListener;
	// public OnItemClickListener tvlItemClickListener;

	private Boolean enabled  = true;           // click-touch enabled!
 
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jTreeListView (Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
 
       super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
 
       LAMWCommon = new jCommons(this, context, pascalObj);

       onItemClickListener = new OnItemClickListener(){
           /*.*/public void onItemClick(AdapterView<?> parent, View v, int position, long id){  //please, do not remove /*.*/ mask for parse invisibility!
			   // Log.i("jTreeViewList", "onItemClick of item "+id+" at position "+position);
               if (enabled) {
				   final int idFromTag = ((Long) v.getTag()).intValue();
				   // mSimpleAdapter.handleItemClick(v, idFromTag);
                   mFocusedNode = id;
                   controls.pOnClickTreeViewItem(pascalObj, idFromTag, Captions.get(idFromTag));
               }
           };
       };
       this.setOnItemClickListener(onItemClickListener);

	   this.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            /*.*/public boolean onItemLongClick(AdapterView<?> parent, View v, int position, long id) {
                if (enabled) {
				   final int idFromTag = ((Long) v.getTag()).intValue();
                    // mLastSelectedItem = position;
                    controls.pOnLongClickTreeViewItem(pascalObj, idFromTag, Captions.get(idFromTag));
                }
                return false;
            }
        });

		mManager = new InMemoryTreeStateManager<Long>();
	    mManager.setVisibleByDefault(false);
        mSimpleAdapter = new jTreeViewAdapter((Activity)context, this, mSelected, mManager, 1);
        // setAdapter(mSimpleAdapter);            // Can't call this until numberOfLevels is set
	    // setCollapsible(true);                  // same
    } //end constructor
 
    public void jFree() {
       //free local objects...
   	 setOnClickListener(null);
	 LAMWCommon.free();
    }
  
    public void SetViewParent(ViewGroup _viewgroup) {
	 LAMWCommon.setParent(_viewgroup);
    }
 
    public ViewGroup GetParent() {
       return LAMWCommon.getParent();
    }
 
    public void RemoveFromViewParent() {
   	 LAMWCommon.removeFromViewParent();
    }
 
    public View GetView() {
       return this;
    }
 
    public void SetLParamWidth(int _w) {
   	 LAMWCommon.setLParamWidth(_w);
    }
 
    public void SetLParamHeight(int _h) {
   	 LAMWCommon.setLParamHeight(_h);
    }
 
    public int GetLParamWidth() {
       return LAMWCommon.getLParamWidth();
    }
 
    public int GetLParamHeight() {
	 return  LAMWCommon.getLParamHeight();
    }
 
    public void SetLGravity(int _g) {
   	 LAMWCommon.setLGravity(_g);
    }
 
    public void SetLWeight(float _w) {
   	 LAMWCommon.setLWeight(_w);
    }
 
    public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
       LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
    }
 
    public void AddLParamsAnchorRule(int _rule) {
	 LAMWCommon.addLParamsAnchorRule(_rule);
    }
 
    public void AddLParamsParentRule(int _rule) {
	 LAMWCommon.addLParamsParentRule(_rule);
    }
 
    public void SetLayoutAll(int _idAnchor) {
   	 LAMWCommon.setLayoutAll(_idAnchor);
    }
 
    public void ClearLayoutAll() {
	 LAMWCommon.clearLayoutAll();
    }
 
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    
	public int RootNode() {
		return ROOT.intValue();
	}
 
    public void SetLevels(int _count) {
       mSimpleAdapter.setLevels(_count);
	   setAdapter(mSimpleAdapter);
	   // setHandleTrackballPress(false);
	   setCollapsible(true);
    }
 
    public void Clear() {
		mManager.clear();
	}

    public int AddChild(int parent_id) {
		mLastAddedId += 1;
		if (parent_id == ROOT.intValue()) {
			mManager.addAfterChild(null, mLastAddedId, null);
		}
		else {
			mManager.addAfterChild((long)parent_id, mLastAddedId, null);
		}
		return (int)mLastAddedId;
	}
	
	public void SetNodeCaption(int node_id, String caption) {
		Captions.put(node_id, caption);
	}
	
	public String GetNodeData(int node_id) {
		return Captions.get(node_id);
	}
	
	public int GetFirstChild(int parent_id) {
		List<Long> children = mManager.getChildren((long)parent_id);
		if (children.isEmpty()) {
			return ROOT.intValue();
		} else {
			return children.get(0).intValue();
		}
	}
	
	public int GetNextSibling(int node_id) {
		Long id = mManager.getNextSibling((long)node_id);
		if (id == null) {
			id = ROOT;
		} 
		return id.intValue();
	}
	
	public boolean GetNodeHasChildren(int node_id) {
		return !mManager.getChildren((long)node_id).isEmpty();
	}
	
	public void ToggleNode(int node_id) {
		TreeNodeInfo<Long> ni = mManager.getNodeInfo((long)node_id);
		boolean visible = ni.isExpanded();
		if (visible) {
			mManager.collapseChildren((long)node_id);
		}
		else {
			mManager.expandDirectChildren((long)node_id);
		}
	}
	
	public void SetFocusedNode(int node_id) {
		this.mFocusedNode = (long)node_id;
	}
	
	public int GetParentNode(int node_id) {
		return mManager.getParent((long)node_id).intValue();
	}
}
